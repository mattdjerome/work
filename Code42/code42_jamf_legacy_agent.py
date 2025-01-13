#!/usr/bin/env python3
from local_credentials import client_id as c42_clientid, client_secret as c42_secret, code42_base_url
from local_credentials import jamf_user, jamf_password, jamf_hostname
import requests
import json
import csv
import datetime

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
        if app_name == "LEGACY":
            code42_computer_list.append(hostname)
            total_count = total_count + 1
    index += 1



#####################################
# Compare lists for actine in jamf with legacy agents
#####################################
# datetime object containing current date and time
date = datetime.date.today()

    
total_count = 0
with open(f'Code42_JAMF_legacy_Code42_{date}.csv', mode='wt', encoding='utf-8') as report_output:
    writer = csv.writer(report_output)
    writer.writerow(('Active Status','Hostname', 'Last Code42 Heartbeat', 'App Type'))
    for computer in code42_data['agents']:
        app_name = computer['agentType']
        if computer['name'] in jamf_computer_list and app_name == 'COMBINED':
            total_count += 1
            writer.writerow((computer['active'], computer['osHostname'], computer['lastConnected'], app_name ))
print(total_count)