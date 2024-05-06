#!/usr/bin/env python3
from local_credentials import jamf_user, jamf_password, jamf_hostname, client_id as c42_clientid, client_secret as c42_secret, code42_base_url
import json
import requests

#####################################
# Retrive JAMF Data
#####################################
def jamf_data(jamf_url, api_token):
	headers = {
		'accept': 'application/json',
		'Authorization': f'Bearer {api_token}',
	}
	
	params = {
		'section': [
			'GENERAL',
		],
	'page': '0',
	'page-size': '1000',
	'sort': 'id:asc',
}
	response = requests.get(jamf_hostname + '/api/preview/computers?page=0&size=100&pagesize=100&page-size=600&sort=name%3Aasc', params=params, headers=headers)
	results = response.json()
	return results['results']

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

##### Retrieve Jamf Computer List #####
jamf_token = get_uapi_token(jamf_user, jamf_password, jamf_hostname)
jamf_data_raw = jamf_data(jamf_hostname,jamf_token)
jamf_computer_list = []
for computer in jamf_data_raw:
	jamf_computer_list.append(computer['name'])
	
##### Retrieve Code42 Backup List #####
print("stop")