
#!/usr/local/ec/bin/python3

import json
import requests
import subprocess

# Retrieve API Bearer token
def get_uapi_token(jamf_user, jamf_password, jamf_hostname):
#   jamf_test_url = jamf_hostname + "/uapi/auth/tokens"
    jamf_test_url = jamf_hostname + "/api/v1/auth/token"
    header = {'Accept': 'application/json', }
    record = requests.post(url=jamf_test_url, headers=header, auth=(jamf_user, jamf_password))
    response_json = record.json()
    print(response_json)
    return response_json['token']

# Check installed applications
def installed_app(results, app):
    applications=[]
    applications = subprocess.run ('ls /Applications', shell=True, check=True,
        stdout=subprocess.PIPE,universal_newlines=True)
    full_list = applications.stdout
    if app in full_list:
        return True
    else:
        return False
    
# Get Computer name
def computer_name(data):
    host_name = data['general']['name']
    print(host_name)
    return host_name



########### Stuff Happens #############
error=[]
requirement=[]
COUNT = 0

COMPUTERS_URL = "https://emersoncollective.jamfcloud.com/JSSResource/computers"

headers = {
    "Accept": "application/json",
    "Authorization": "Basic YXBpX3VzZXI6cFB4b3ppSDU5WTJqMURBU0lvYTBuMQ=="
}

response = requests.request("GET", COMPUTERS_URL, headers=headers)
results = response.json()

id_number=results['computers']
uapi_token = get_uapi_token('api_user', 'pPxoziH59Y2j1DASIoa0n1',
    'https://emersoncollective.jamfcloud.com')

for i in id_number:
    hostname = i['name']
    number = i['id']
    url = f"https://emersoncollective.jamfcloud.com/uapi/v1/computers-inventory-detail/{number}"
    jamf_url=f"https://emersoncollective.jamfcloud.com/computers.html?id={number}&o=r"
    headers = {
    "Accept": "application/json",
    "Authorization": f"Bearer {uapi_token}"
}
    
    response = requests.request("GET", url, headers=headers)
    results = response.json()
    FALCON = installed_app(results, "Falcon.app")
    if FALCON is False:
        error.append(FALCON)
    if len(error) > 0:
        computer_data=(f"\nJAMF URL - {jamf_url}\nHostname - {hostname}\nCrowdstrike Falcon Installed - {FALCON}")
        COUNT += 1
        print(computer_data)
        print(error)
        file_ticket(error, hostname, computer_data)
        error.clear()
        