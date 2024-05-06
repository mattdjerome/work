#!/usr/bin/env python3
from local_credentials import client_id as c42_clientid, client_secret as c42_secret, code42_base_url
from local_credentials import jamf_user, jamf_password, jamf_hostname
import requests
import json
import csv
import datetime
import argparse
from falconpy import Hosts

#####################################
# Retrive JAMF API Bearer Token
#####################################
def get_uapi_token(jamf_user, jamf_password, jamf_hostname):
    jamf_test_url = jamf_hostname + "/api/v1/auth/token"
    header = {'Accept': 'application/json', }
    record = requests.post(url=jamf_test_url, headers=header, auth=(jamf_user, jamf_password))
    response_json = record.json()
    return response_json['token']

#####################################
# Retrive Code42 API Bearer Token
#####################################
def get_falcon_token(client_id,client_secret):
    headers = {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
    }
    
    data = {
        'client_id': 'cc13fbde688843b69995fc506e0a5feb',
        'client_secret': 'v9G3B4tlkg6Q0V7TOio5Un2ZLaPHwrWcYFDI1jS8',
    }
    
    response = requests.post('https://api.us-2.crowdstrike.com/oauth2/token', headers=headers, data=data)
    result=response.json()
    return(result['access_token'])


#####################################
# Get JAMF Computer Data
#####################################

def jamf_data(jamf_url, api_token):
    headers = {
        'accept': 'application/json',
        'Authorization': f'Bearer {api_token}',
    }

    params = {
        'section': [
            'GENERAL',
            'USER_AND_LOCATION',
    ],
    'page': '0',
    'page-size': '1000',
    'sort': 'id:asc',
}
    response = requests.get(jamf_hostname + '/api/preview/computers?page=0&size=100&pagesize=100&page-size=600&sort=name%3Aasc', params=params, headers=headers)
    results = response.json()
    return results['results']


#####################################
# Get Code42 Token
#####################################
def get_code42_token(code42_base_url, client_id, client_secret):    
    headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
}

    response = requests.post(f'{code42_base_url}v1/oauth', headers=headers, auth=(client_id, client_secret))

    result = response.json()
    token = result['access_token']
    return token
#####################################
# Get Code42 Computer List
#####################################

def get_code42_data(token, code42_base_url):
    headers = {
        'Authorization': f'Bearer {token}',
}
    params = {
        'active': 'true',
        'pageSize': '1000'
}
    response = requests.get(f'{code42_base_url}v1/agents', params=params, headers=headers)
    code42_data = response.json()
    return code42_data


#####################################
# Retrieve JAMF Computer Lists
#####################################

jamf_token = get_uapi_token(jamf_user, jamf_password, jamf_hostname)
jamf_computer_data = jamf_data(jamf_hostname, jamf_token)
jamf_computer_list = []
for computer in jamf_computer_data:
    jamf_computer_list.append(computer['name'])

#####################################
# Retrieve  Computer ID Lists
#####################################
    
falcon_token=get_falcon_token('cc13fbde688843b69995fc506e0a5feb', 'v9G3B4tlkg6Q0V7TOio5Un2ZLaPHwrWcYFDI1jS8')
headers = {
    'Authorization': f'Bearer {falcon_token}',
    'Accept': 'application/json',
}

response = requests.get(

    "https://api.us-2.crowdstrike.com//devices/queries/devices/v1?limit=700",    headers=headers,
)
falcon_computer_id = response.json()


#####################################
# Retrieve Falcon Computer Data Lists
#####################################



def device_list(off: int, limit: int, sort: str):
    result = falcon.query_devices_by_filter(limit=limit, offset=off, sort=sort)
    new_offset = 0
    total = 0
    returned_device_list = []
    if result["status_code"] == 200:
        new_offset = result["body"]["meta"]["pagination"]["offset"]
        total = result["body"]["meta"]["pagination"]["total"]
        returned_device_list = result["body"]["resources"]
        
    return new_offset, total, returned_device_list

def device_detail(aids: list):

    result = falcon.get_device_details(ids=aids)
    device_details = []
    if result["status_code"] == 200:
        # return just the aid and agent version
        for device in result["body"]["resources"]:
            res = {}
            res["hostname"] = device.get("hostname", None)
            res["agent_version"] = device.get("agent_version", None)
            device_details.append(res)
    return device_details

falcon = Hosts(client_id='',
               client_secret='',
               base_url='',
               )
SORT = "hostname.desc"
OFFSET = 0      # Start at the beginning
DISPLAYED = 0   # Running count
TOTAL = 1       # Assume there is at least one
LIMIT = 500     # Quick limit to prove pagination
falcon_computers = []
while OFFSET < TOTAL:
    OFFSET, TOTAL, devices = device_list(OFFSET, LIMIT,SORT)
    falcon_details = device_detail(devices)
    for detail in falcon_details:
        DISPLAYED += 1
        falcon_computers.append(detail['hostname'])



#####################################
# Retrieve Code42 Computer Lists
#####################################
code42_token = get_code42_token(code42_base_url, c42_clientid, c42_secret)
code42_data = get_code42_data(code42_token, code42_base_url)
code42_computer_list = []
index = 0
total_count = 0
index_max = len(code42_data['agents'])
while index < index_max:
    if code42_data['agents'][index]['active'] is True:
        hostname = code42_data['agents'][index]['osHostname']
        app_name = code42_data['agents'][index]['agentType']
        agent_version = code42_data['agents'][index]['productVersion']
        if app_name == "CODE42AAT":
            code42_computer_list.append(hostname)
            total_count = total_count + 1
    index += 1



#####################################
# Compare lists
#####################################
# datetime object containing current date and time
date = datetime.date.today()

    
total_count = 0
with open(f'Code42_JAMF_Sanity_Check_{date}.csv', mode='wt', encoding='utf-8') as report_output:
    writer = csv.writer(report_output)
    writer.writerow(('Active Status','Hostname', 'Last Code42 Heartbeat', 'App Type'))
    for computer in code42_data['agents']:
        app_name = computer['agentType']
        if computer['name'] not in jamf_computer_list:
            total_count += 1
            writer.writerow((computer['active'], computer['osHostname'], computer['lastConnected'], app_name ))
print(total_count)
