import requests
import json
from local_credentials import client_id, client_secret, code42_base_url 
headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
}

data = f'grant_type=client_credentials&client_id={client_id}&client_secret={client_secret}'

response = requests.post(f'{code42_base_url}v1/oauth', headers=headers, data=data)
result = response.json()
c42_token = result['access_token']
#print(c42_token)

#####################################
# Get Code42 Computer List
#####################################

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
    return code42_data

def get_code42_users(token,code42_base_url):
    headers = {
        'Authorization': f'Bearer {token}',
    }
    params = {
        'active': 'true',
        'pageSize': '1000'
    }
    response = requests.get(f'{code42_base_url}v1/users', params=params, headers=headers)
    users = response.json()
    return users['users']

code42_computers = get_code42_data(c42_token, code42_base_url)
code42_users = get_code42_users(c42_token, code42_base_url)
with open(f'Code42_backup_status.csv', mode='wt', encoding='utf-8') as report_output:
    writer = csv.writer(report_output)
    writer.writerow(('Code42 User ID', 'Code42 Hostname', 'Code42 Username', 'Code42 Last Contact', 'Code42 Last Activity','Code42 Last Backup'))
    for agents in code42_computers['agents']:
        if 'CODE42AAT' in agents['agentType']:
            continue
        for user in code42_users:
            if agents['userId'] in user['userId']:
                writer.writerow((user['userId'],agents["osHostname"], user['username'], ))

            