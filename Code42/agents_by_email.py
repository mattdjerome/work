#!/usr/bin/env python3

import csv
import requests
import json
from local_credentials import client_id as c42_clientid, client_secret as c42_secret, code42_base_url
from local_credentials import jamf_user, jamf_password, jamf_hostname

#####################################
# Read Okta spreadsheet email addresses
#####################################
path = '/Users/mjerome/Downloads/okta_data_082323.csv'
oktaEmailList = []

with open(path, 'r') as f:
    reader = csv.reader(f)
    amr_csv = list(reader)
    for line in amr_csv:
        if line[0] == 'Username':
            continue
        else:
            oktaEmailList.append(line[0])

#####################################
# Functions to Get Jamf Token, Users and Computers
#####################################
def get_uapi_token(jamf_user, jamf_password, jamf_hostname):
    jamf_test_url = jamf_hostname + "/api/v1/auth/token"
    header = {'Accept': 'application/json', }
    record = requests.post(url=jamf_test_url, headers=header, auth=(jamf_user, jamf_password))
    response_json = record.json()
    return response_json['token']

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
# Functions To Get Code Token, Users and Computers
#####################################
def get_code42_token(code42_base_url, client_id, client_secret):    
    headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
}
    
    response = requests.post(f'{code42_base_url}v1/oauth', headers=headers, auth=(client_id, client_secret))
    
    result = response.json()
    token = result['access_token']
    return token

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
    return code42_data['agents']

def get_code42_users(token, code42_base_url):
    headers = {
        'Authorization': f'Bearer {token}',
}
    params = {
        'active': 'true',
        'pageSize': '1000'
}
    response = requests.get(f'{code42_base_url}v1/users', params=params, headers=headers)
    code42_users = response.json()
    return code42_users['users']

def get_code42_devices_by_uuid(userId,token, code42_base_url):
    headers = {
        'Authorization': f'Bearer {token}',
}
    params = {
        'active': 'true',
        'pageSize': '1000'
}
    response = requests.get(f'{code42_base_url}v1/users/{userId}/devices', params=params, headers=headers)
    code42_devices = response.json()
    return code42_devices['devices']


#####################################
# Get Data
#####################################
code42_uid_dict={}
jamf_token = get_uapi_token(jamf_user, jamf_password, jamf_hostname)
jamf_computers_raw = jamf_data(jamf_hostname,jamf_token)
code42_token = get_code42_token(code42_base_url, c42_clientid, c42_secret)
code42_data = get_code42_data(code42_token, code42_base_url)
code42_users = get_code42_users(code42_token, code42_base_url)

for users in code42_users:
    code42_uid_dict[users['username']] = users['userId']

full_data = {}
code42_dict = {}
okta_no_jamf = []
jamf_users = []
okta_no_code42 = []
dict_index = -1
for oktaUser in oktaEmailList:
    try:
        computers = get_code42_devices_by_uuid(code42_uid_dict[oktaUser], code42_token, code42_base_url)
        for entry in computers:
            print(oktaUser, entry['name'])
            full_data[dict_index] = 
    except KeyError:
        okta_no_code42.append(oktaUser)
        continue
