#!/usr/bin/env python3

import requests
import json
from local_credentials import jamf_user, jamf_password, jamf_hostname

def get_uapi_token(jamf_user, jamf_password, jamf_hostname):
    
    jamf_test_url = jamf_hostname + "/uapi/auth/tokens"
    headers = {'Accept': 'application/json', }
    response = requests.post(url=jamf_test_url, headers=headers, auth=(jamf_user, jamf_password))
    response_json = response.json()
    return response_json['token']

api_token = get_uapi_token(jamf_user,jamf_password,jamf_hostname)


def get_jamf_computers(token,jamf_hostname):
    url = f"{jamf_hostname}/api/v1/computers-inventory?section=GENERAL"
    
    payload={}
    headers = {
        'Authorization': f'Bearer {token}',
        
    }
    
    response = requests.request("GET", url, headers=headers, data=payload)
    response_json=response.json()
    return response_json
    
#jamf_computer_data = get_jamf_computers(api_token, jamf_hostname)

total = 0

total_consumed = 0
current_page = 0
page_size = 100
stop_paging = False
while not stop_paging:
    headers = {'Accept': 'application/json', 'Authorization': 'Bearer ' + api_token}
    response = requests.get(url=jamf_hostname + "/api/v1/computers-inventory?section=GENERAL&page-size=" + str(page_size) + "&page=" + str(current_page) + "&sort=id%3Aasc", headers=headers)
    response_json = response.json()
#   print(json.dumps(response_json, indent=3))
    total_computers = response_json['totalCount']
    for computer_id in response_json['results']:
        computer_name = computer_id['general']['name']
        print(computer_name)
            
    current_page += 1
    total_consumed += len(response_json['results'])
    stop_paging = (total_computers == total_consumed)