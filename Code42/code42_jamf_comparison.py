#!/usr/bin/env python3


import requests
from local_credentials import client_id, client_secret, code42_base_url
import json
import datetime
import csv

#########################################
#
# Retrieve Code42 Bearer Token
#
#########################################

headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
}

response = requests.post(f'{code42_base_url}v1/oauth', headers=headers, auth=(client_id, client_secret))

result = response.json()
token = result['access_token']

#########################################
#
# Retrieve Code42 Agent data
#
#########################################
date = datetime.date.today()

headers = {
    'Authorization': f'Bearer {token}',
}
params = {
    'active': 'true',
    'pageSize': '1000'
}
response = requests.get(f'{code42_base_url}v1/agents', params=params, headers=headers)
computer_results = response.json()
index = 0
index_max = len(computer_results['agents'])
agent_ids = []
with open(f'Code42_Version_report_{date}.csv', mode='wt', encoding='utf-8') as report_output:
    writer = csv.writer(report_output)
    writer.writerow(('Active Status','Hostname','Last Connected','Agent Type', 'Agent Version'))
    while index < index_max:
        agent_ids.append(computer_results['agents'][index]['agentId'])
        
        if computer_results['agents'][index]['active'] is True:
            hostname = computer_results['agents'][index]['osHostname']
            app_name = computer_results['agents'][index]['agentType']
            agent_version = computer_results['agents'][index]['productVersion']
            if agent_version < "12.0.0" and app_name != "CODE42AAT":
                writer.writerow((computer_results['agents'][index]['active'],hostname, computer_results['agents'][index]['lastConnected'],app_name, agent_version))
        index += 1
        