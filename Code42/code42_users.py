#!/usr/bin/env python3

import requests
import json
from local_credentials import client_id as c42_clientid, client_secret as c42_secret, code42_base_url

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


token = get_code42_token(code42_base_url, c42_clientid, c42_secret)
user_data = get_code42_users(token, code42_base_url)
for user in user_data:
    if user['username'] == "mjerome@emersoncollective.com":
        print(user)
        
993592636522003346

def get_code42_user_data(token, code42_base_url):
    headers = {
        'Authorization': f'Bearer {token}',
}
    params = {
        'active': 'true',
        'pageSize': '1000'
}
    response = requests.get(f'{code42_base_url}v1/users/993592636522003346/devices', params=params, headers=headers)
    code42_users = response.json()
    return code42_users['devices']

data = get_code42_user_data(token, code42_base_url)
print(data)