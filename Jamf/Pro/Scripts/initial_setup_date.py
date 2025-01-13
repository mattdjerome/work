#!/usr/bin/env python3

from local_credentials import jamf_user, jamf_password, jamf_hostname
import requests
import json

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
# Retrive JAMF data
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
    response = requests.get(jamf_url + '/api/preview/computers?page=0&size=100&pagesize=100&page-size=600&sort=name%3Aasc', params=params, headers=headers)
    results = response.json()
    return results['results']



jamf_token = get_uapi_token(jamf_user, jamf_password, jamf_hostname)
jamf_computer_data = jamf_data(jamf_hostname, jamf_token)
for data in jamf_computer_data:
    print(data['id'],data['lastEnrolledDate'])