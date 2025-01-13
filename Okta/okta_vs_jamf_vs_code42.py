#!/usr/bin/env python3

import csv
import requests
import json
from local_credentials import client_id as c42_clientid, client_secret as c42_secret, code42_base_url
from local_credentials import jamf_user, jamf_password, jamf_hostname
from datetime import date
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


#####################################
# Code Begins Here
#####################################
#####################################
# Read Okta spreadsheet email addresses
#####################################
path = '/Users/mjerome/Downloads/more_okta_data.csv'
oktaEmailList = []

with open(path, 'r') as f:
    reader = csv.reader(f)
    amr_csv = list(reader)
    for line in amr_csv:
#       print(line)
        if line[0] != "Hostname" and line[0] != "Staff Member":
            address=line[1]
            address = address.splitlines()
#           for email in address:
            oktaEmailList.append(address)
        else:
            continue
        
#####################################
# Get Jamf Data
#####################################
jamf_token = get_uapi_token(jamf_user, jamf_password, jamf_hostname)
jamf_computers_raw = jamf_data(jamf_hostname,jamf_token)
jamf_computers = {}
oktaAddresses = []
###### Need to seperate out the email addresses as the read all in the same string
for address in oktaEmailList:
    for possible_email in address:
       oktaAddresses.append(possible_email)

today = date.today()

#####################################
# Start working with data
#####################################
code42_token = get_code42_token(code42_base_url, c42_clientid, c42_secret)
code42_data = get_code42_data(code42_token, code42_base_url)
code42_uids = get_code42_users(code42_token, code42_base_url)

okta_users = {}
jamf_dict = {}
code42_backup_dict = {}
code42_dlp_dict = {}
for email_address in oktaAddresses:
    okta_users[email_address] = email_address
for jamf_user in jamf_computers_raw:
    jamf_username = jamf_user['location']['username']
    jamf_computer_name = jamf_user['name']
    jamf_last_checkin = jamf_user['lastContactDate']
    jamf_dict[jamf_username] = {'JamfComputer':jamf_computer_name,'JamfLastCheckin':jamf_last_checkin}

for uid in code42_uids:
    for code42_computer in code42_data:
        if code42_computer['userId'] == uid['userId'] and code42_computer['agentType'] == "CODE42":
            code42_username = uid['username']
            try:
                if code42_backup_dict[code42_username]: 
                    print("ping")
                    code42_backup_dict[code42_username].append({'Code42Computer':code42_computer['name'],'Code42LastConnected':code42_computer['lastConnected']})
            except KeyError:
                    code42_backup_dict[code42_username]=[{'Code42Computer':code42_computer['name'],'Code42LastConnected':code42_computer['lastConnected']}]
for uid in code42_uids:
    for code42_computer in code42_data:
        if code42_computer['userId'] == uid['userId'] and code42_computer['agentType'] == "CODE42AAT":
            code42_username = uid['username']
            code42_dlp_dict[code42_username] = {'Code42Computer':code42_computer['name'],'Code42LastConnected':code42_computer['lastConnected']}
            
with open(f'oktaVsJamfVsCode42VsFalcon-{today}.csv', mode='wt', encoding='utf-8') as report_output:
    writer = csv.writer(report_output)
    writer.writerow(('Okta User','Jamf Computer', 'Jamf Last Checkin','Code42 Backup Computer','Code42 Backup Last Contact','Code42 DLP Computer','Code42 DLP Last Contact'))
    for address in oktaAddresses:
        try:
            writer.writerow((address,jamf_dict[address]['JamfComputer'],jamf_dict[address]['JamfLastCheckin'],code42_backup_dict[address],code42_backup_dict[address]['Code42LastConnected'],code42_dlp_dict[address]['Code42Computer'],code42_dlp_dict[address]['Code42LastConnected']))
        except:
            writer.writerow((address,"Null Error"))