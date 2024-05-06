#!/usr/bin/env python3

from local_credentials import jamf_user, jamf_password, jamf_hostname
import requests
import json

def get_uapi_token(jamf_hostname,jamf_user, jamf_password):
	
	jamf_test_url = jamf_hostname + "/api/v1/auth/token"
	headers = {'Accept': 'application/json', }
	response = requests.post(url=jamf_test_url, headers=headers, auth=(jamf_user, jamf_password))
	response_json = response.json()
	
	return response_json['token']

def get_computers(jamf_hostname, bearer_token):
	full_url = jamf_hostname + '/api/v1/computers-inventory'
	headers = {
		'accept': 'application/json',
		'Authorization': f'Bearer {bearer_token}',
	}
	
	params = {
		'section': [
			'GENERAL',
			'APPLICATIONS',
			'USER_AND_LOCATION',
		],
		'page': '0',
		'page-size': '1500',
		'sort': 'general.name:asc',
	}
	
	response = requests.get(full_url, params=params, headers=headers)
	results = response.json()
	return results['results']
####### Get Auth Token #########
token = get_uapi_token(jamf_hostname,jamf_user, jamf_password)

####### Put all Computers int oa Local Variable #######
all_computers = get_computers(jamf_hostname,token)
print("")
####### Creates a dictionary of jss id, full name, email and department #######
computer_record = {}
for user in all_computers:
	email = user['userAndLocation']['email']
	full_name = user['userAndLocation']['realname']
	computer = user['general']['name']
	
	jss_id = user['id']
	for department in user['userAndLocation']['extensionAttributes']:
		#		print(department['name'])
		if 'LDAP-Department' in department['name']:
			department = department['values']
			computer_record = {computer: [jss_id,full_name,email,*department]} #add the asterisk to remove the brackets since department is technically a list
#			print(department)

		else:
				break
		print(computer_record)
