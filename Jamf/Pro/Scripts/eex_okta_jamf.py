#!/usr/local/bin/python3

import csv
import json
from local_credentials import jamf_user, jamf_password, jamf_hostname
import requests

#####################################
# Functions to Get Jamf Token, Users and Computers
#####################################
def get_uapi_token(jamf_user, jamf_password, jamf_hostname):
	jamf_test_url = jamf_hostname + "/api/v1/auth/token"
	header = {'Accept': 'application/json', }
	record = requests.post(url=jamf_test_url, headers=header, auth=(jamf_user, jamf_password))
	response_json = record.json()
	return response_json['token']

def jamf_computer_data(jamf_url, api_token):
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

def jamf_mobile_data(jamf_url, api_token):
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
		'page-size': '100',
		'sort': 'displayName:asc',
	}
	
	response = requests.get('https://emersoncollective.jamfcloud.com/api/v2/mobile-devices/detail', params=params, headers=headers)	
	results = response.json()
	return results['results']

#####################################
# Read Okta spreadsheet email addresses
#####################################
path = '/Users/mjerome/Downloads/eex_okta.csv'
oktaEmailList = []

with open(path, 'r') as f:
	reader = csv.reader(f)
	amr_csv = list(reader)
	for line in amr_csv:
		if line != "Username":
			address=line[0]
			if "@elementalexcelerator.com" in address:
				oktaEmailList.append(address)
		else:
			continue
jamf_token = get_uapi_token(jamf_user, jamf_password, jamf_hostname)
jamf_computers = jamf_computer_data(jamf_hostname, jamf_token)
jamf_mobile = jamf_mobile_data(jamf_hostname, jamf_token)
#print(jamf_mobile)
#print('')
print("EEx Computers")
for user in oktaEmailList:
	user = user.lstrip("['").rstrip("']")
	for computer in jamf_computers:
		if user == computer['location']['username']:
			print(user,computer['location']['username'],computer['name'])
		else:
			continue
print("EEx Mobile Devices")
for user in oktaEmailList:
	user = user.lstrip("['").rstrip("']")
#	print(user)
	for device in jamf_mobile:
		if user in device['userAndLocation']['emailAddress']:
			print(user,device['general']['displayName'],device['userAndLocation']['emailAddress'])
		else:
			continue
			