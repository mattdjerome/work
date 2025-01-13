#!/usr/bin/env python3
from local_credentials import client_id as c42_clientid, client_secret as c42_secret, code42_base_url
from local_credentials import jamf_user, jamf_password, jamf_hostname
import requests
import json
from falconpy import Hosts
from datetime import datetime
import csv
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
            'HARDWARE'
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
# Get Code42 Backup Computer List
#####################################

def get_code42_backup_data(token, code42_base_url):
    headers = {
        'Authorization': f'Bearer {token}',
    }
    params = {
        'active': 'true',
        'pageSize': '1000',
        'agentType': 'CODE42'
    }
    response = requests.get(f'{code42_base_url}v1/agents', params=params, headers=headers)
    code42_backup_data = response.json()
    return code42_backup_data

#####################################
# Get Code42 Incydr Computer List
#####################################

def get_code42_incydr_data(token, code42_base_url):
    headers = {
        'Authorization': f'Bearer {token}',
    }
    params = {
        'active': 'true',
        'pageSize': '1000',
        'agentType': 'CODE42-AAT'
    }
    response = requests.get(f'{code42_base_url}v1/agents', params=params, headers=headers)
    code42_backup_data = response.json()
    return code42_backup_data


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
    os_type = "Mac"
    result = falcon.get_device_details(ids=aids)
    device_details = []
    if result["status_code"] == 200:
        # return just the aid and agent version
        for device in result["body"]["resources"]:
            res = {}
            if "mini" not in device['system_product_name'] and "Mac" in device['platform_name']:
                res["hostname"] = device.get("hostname", None)
                res["agent_version"] = device.get("agent_version", None)
                device_details.append(res)
    return device_details

falcon = Hosts(client_id='cc13fbde688843b69995fc506e0a5feb',
    client_secret='v9G3B4tlkg6Q0V7TOio5Un2ZLaPHwrWcYFDI1jS8',
    base_url='https://api.us-2.crowdstrike.com',
)


response = falcon.get_device_details()


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
# Retrieve JAMF Computer Lists
#####################################

jamf_token = get_uapi_token(jamf_user, jamf_password, jamf_hostname)
jamf_computer_data = jamf_data(jamf_hostname, jamf_token)
jamf_computer_list = []

for computer in jamf_computer_data:
    if "mini" in computer['modelIdentifier']:
        continue
    else:
        try:
            jamf_computer_list.append(computer['name'])
        except:
            jamf_computer_list.append({computer['name']} + "ERROR")

#####################################
# Retrieve Code42 Backup Computer Lists
#####################################
code42_token = get_code42_token(code42_base_url, c42_clientid, c42_secret)
code42_backup_data = get_code42_backup_data(code42_token, code42_base_url)
code42_backup_list = []
index = 0
total_count = 0
index_max = len(code42_backup_data['agents'])
while index < index_max:
    if code42_backup_data['agents'][index]['active'] is True:
        hostname = code42_backup_data['agents'][index]['osHostname']
        code42_backup_list.append(code42_backup_data['agents'][index]['osHostname'])
        total_count = total_count + 1
    index += 1
    
    
#####################################
# Retrieve Code42 DLP Computer Lists
#####################################
code42_token = get_code42_token(code42_base_url, c42_clientid, c42_secret)
code42_Incydr_data = get_code42_backup_data(code42_token, code42_base_url)
code42_Incydr_list = []
index = 0
total_count = 0
index_max = len(code42_Incydr_data['agents'])
while index < index_max:
    if code42_Incydr_data['agents'][index]['active'] is True:
        hostname = code42_Incydr_data['agents'][index]['osHostname']
        code42_Incydr_list.append(code42_Incydr_data['agents'][index]['osHostname'])
        total_count = total_count + 1
    index += 1
    
    
#####################################
# Compare lists
#####################################
date = datetime.now()
combined_computer_list = code42_backup_list + jamf_computer_list + falcon_computers

combined_no_dupes = list(set(combined_computer_list))

with open(f'Host_Entry_Comparison_{date}.csv', mode='wt', encoding='utf-8') as report_output:
    writer = csv.writer(report_output)
    writer.writerow(('Hostname', 'In Jamf', 'In Backup', 'In Incydr', 'In Falcon'))
    for computer in combined_no_dupes:
        if computer in jamf_computer_list:
            in_jamf = True
        else:
            in_jamf = False
        if computer in code42_backup_list:
            in_code42_backup = True
        else:
            in_code42_backup = False
        if computer in code42_Incydr_list:
            in_code42_incydr = True
        else:
            in_code42_incydr = False
        if computer in falcon_computers:
            in_falcon = True
        else:
            in_falcon = False
        if not in_jamf and in_falcon:
            jamf_no_falcon_yes = jamf_no_falcon_yes + 1

        writer.writerow((computer, in_jamf, in_code42_backup, in_code42_incydr, in_falcon))