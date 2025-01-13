#!/usr/bin/env python3

import json
import requests


##### FUNCTIONS #####
def jamf_computer_search(token, id ):   
    headers = {
        'accept': 'application/json',
        'Authorization': f'Bearer {token}'}

    response = requests.get(f'https://emersoncollective.jamfcloud.com/JSSResource/advancedcomputersearches/id/{id}', headers=headers)
    results = response.json()
    return results['advanced_computer_search']['computers']

def get_uapi_token(jamf_user, jamf_password, jamf_hostname):
    #   jamf_test_url = jamf_hostname + "/uapi/auth/tokens"
    jamf_test_url = jamf_hostname + "/api/v1/auth/token"
    header = {'Accept': 'application/json', }
    record = requests.post(url=jamf_test_url, headers=header, auth=(jamf_user, jamf_password))
    response_json = record.json()
    return response_json['token']

def code42_user_lookup():
    
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
    }
    
    response = requests.post('https://api.us2.code42.com/v1/oauth', headers=headers, auth=('key-622a3f1b-f2c0-4280-8ffb-69a2a7d5b8f1', 'Jf%6xpWLgxGBM#zgMDsnb%ntb%N8pwGsp#xG7CQx'))
    results = response.json()
    token = results['access_token']
    headers = {
            'content-type': 'application/json',
            'authorization': f'Bearer {token}',
        }
        
    user_response = requests.get('https://api.us2.code42.com/v1/users', headers=headers)
    response_json = response.json()

        


    user_results = user_response.json()

#   total = total + 1
    return user_results['users']


def code42_device_lookup():
    
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
    }
    
    response = requests.post('https://api.us2.code42.com/v1/oauth', headers=headers, auth=('key-622a3f1b-f2c0-4280-8ffb-69a2a7d5b8f1', 'Jf%6xpWLgxGBM#zgMDsnb%ntb%N8pwGsp#xG7CQx'))
    results = response.json()
    token = results['access_token']
    headers = {
            'content-type': 'application/json',
            'authorization': f'Bearer {token}',
        }
    
    user_response = requests.get('https://api.us2.code42.com/v1/devices', headers=headers)
    response_json = response.json()
    
    
    
    
    user_results = user_response.json()
    
#   total = total + 1
    return user_results['devices']

token = get_uapi_token("api_user", "pPxoziH59Y2j1DASIoa0n1", "https://emersoncollective.jamfcloud.com")
code42_computers = code42_device_lookup()
print("JAMF Computer Name", "Code42 Username", "Code42 Active Status", "Code42 Blocked Status")
jamf_computer_list = jamf_computer_search(token, "188")
code42_users = code42_user_lookup()
