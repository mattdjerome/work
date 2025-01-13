#!/usr/bin/env python3

import requests
import json
from local_credentials import jamf_user as user, jamf_password as password
import datetime
import csv

def get_uapi_token(jamf_user, jamf_password, jamf_hostname):
#   jamf_test_url = jamf_hostname + "/uapi/auth/tokens"
    jamf_test_url = jamf_hostname + "/api/v1/auth/token"
    header = {'Accept': 'application/json', }
    record = requests.post(url=jamf_test_url, headers=header, auth=(jamf_user, jamf_password))
    response_json = record.json()
    return response_json['token']

jamf_token = get_uapi_token(user, password, "https://emersoncollective.jamfcloud.com")

headers = {
    'accept': 'application/json',
    'Authorization': f'Bearer {jamf_token}',
}

params = {
    'section': [
        'GENERAL',
        'APPLICATIONS',
    ],
    'page': '0',
    'page-size': '600',
    'sort': 'id:asc',
}

response = requests.get('https://emersoncollective.jamfcloud.com/api/v1/computers-inventory', params=params, headers=headers)
results = response.json()
total_count = results['totalCount']
data=results['results']
counter = 1 
total = 0
date = datetime.date.today()
with open(f'Code42_Version_Report_{date}.csv', mode='wt', encoding='utf-8') as report_output:
    writer = csv.writer(report_output)
    writer.writerow(('Name', 'App name', 'Legacy Agent Version','Last JAMF Checkin'))
    for item in data:
        hostname = item['general']['name']
        index = 0
        last_checkin = item['general']['reportDate']
        index_max = len(item['applications'])

        while index < index_max:
            app_name = item['applications'][index]['name']
            app_version = item['applications'][index]['version']
            if app_version < "12.0.0" and "Code42.app" in app_name:
                writer.writerow((hostname , app_name, app_version, last_checkin))
                print(hostname , app_name, app_version, last_checkin)
                
            index = index + 1
        
        

        