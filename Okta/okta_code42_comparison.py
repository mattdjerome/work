#!/usr/bin/env python3

import requests
import json
from local_credentials import client_id as c42_clientid, client_secret as c42_secret, code42_base_url, code42_console,code42_api_account,code42_api_password,okta_key
import py42.sdk
import csv
from datetime import date
###########################################
# Retrieve Okta User Data
###########################################
headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': f'SSWS {okta_key}',
}

next_page = True
next_url = 'https://emersoncollective-admin.okta.com/api/v1/users?filter=status eq "ACTIVE"'
okta_user_list = []
while next_page:
    response = requests.get(next_url, headers=headers)
    response_json = response.json()
    
    next_page = False
    link_raw = response.headers['link'].split(',')
    for item in link_raw:
        if 'next' in item:
            next_raw = item.split(';')
            for url_raw in next_raw:
                if "http" in url_raw:
                    url_raw = url_raw.split('<')[-1]
                    url_raw = url_raw.split('>')[0]
                    next_url = url_raw
                    next_page = True
    for data in response_json:
        try:
            oktaDisplayName = data['profile']['displayName']
        except:
            oktaDisplayName = "DisplayNameError"
        try:
            oktaEmail = data['profile']['email']
            okta_user_list.append(oktaEmail)
        except:
            oktaEmail = "emailError"

###########################################
# User Exclusion list
###########################################
exclusions = ['accounting@emersoncollective.com','scanner@emersoncollective.com','sfdcbox@emersoncollective.com','app.splash@emersoncollective.com','accounting@xqinstitute.org',
    'scanner@xqinstitute.org','app.clearbit@emersoncollective.com','susan.smartt@emersoncollective.com','app.ldap@emersoncollective.com','donnell@chicagocred.com','Dorothy@chicagocred.com',
    'michael@chicagocred.com','monroe@chicagocred.com','necole@chicagocred.com','porsha@chicagocred.com','roberthill@chicagocred.com','shivone@chicagocred.com','robert@chicagocred.com',
    'reimel@chicagocred.com','terrance@chicagocred.com','sherman@chicagocred.com','charita@chicagocred.com','penny@chicagocred.com','LaQuay@chicagocred.com','fsmith@chicagocred.com',
    'gwen@chicagocred.com','fnewman@chicagocred.com','dwoods@chicagocred.com','xpatton@chicagocred.com','amiller@chicagocred.com','bmcdonald@chicagocred.com','ajones@chicagocred.com',
    'pnoel@chicagocred.com','legal@emersoncollective.com','syarbrough@chicagocred.com','william@chicagocred.com','EPAfrontoffice@emersoncollective.com','kanoya@chicagocred.com','dontay@chicagocred.com',
    'henton@chicagocred.com','byron@chicagocred.com','darryl@chicagocred.com','pbradford@chicagocred.com','adriana@chicagocred.com','app.salesforce@emersoncollective.com','iesha@chicagocred.com',
    'lacrisha@chicagocred.com','natasha@chicagocred.com','janice@chicagocred.com','eshia@chicagocred.com','brianna@chicagocred.com','oop_shared_contacts@emersoncollective.com','tawana@chicagocred.com',
    'app.waiverforever@emersoncollective.com','xq.react@xqinstitute.org','kelvin@chicagocred.com','jimmie@chicagocred.com','deandrea@chicagocred.com','anthony@chicagocred.com','jermaine@chicagocred.com',
    'scanner@credmade.com','mark@chicagocred.com','tamyra@chicagocred.com','ahmad@chicagocred.com','XQSalesforce@xqinstitute.org','danielle@chicagocred.com','app.sapling@emersoncollective.com','Shaquita@chicagocred.com',
    'Joanne@chicagocred.com','Lorenzo@chicagocred.com','jevon@chicagocred.com','jeremy@chicagocred.com','DeWayne@chicagocred.com','conwanis@chicagocred.com','Rasheniece@chicagocred.com','reginald@chicagocred.com','Mcgee@chicagocred.com',
    'Terence@chicagocred.com','benefitssupport@emersoncollective.com','xq-ipad@xqinstitute.org','Princess@chicagocred.com','ezra@chicagocred.com','darius@chicagocred.com','info@aspja.com','faduma@chicagocred.com',
    'asehli@chicagocred.com','javon@chicagocred.com','scanner@aspja.com','app.zoom.278@emersoncollective.com','matellio_qa@emersoncollective.com','capacitybuilding@emersoncollective.com','Steven@chicagocred.com',
    'faith@chicagocred.com','editors@xqinstitute.org','latrice@chicagocred.com','techaccounts@emersoncollective.com','app.github@emersoncollective.tech','fuchsia@chicagocred.com','jjones@chicagocred.com','ashle@chicagocred.com',
    'torrence@chicagocred.com','catrina@chicagocred.com','carol@chicagocred.com','takhari@chicagocred.com','traves@chicagocred.com','rsvp@emersoncollective.com',
    'miguel@chicagocred.com','itaccounts@yosemite.co','app.zoom@emersoncollective.com','jgreulich@legatosec.com','blueraspberry@stevejobsarchive.com']
#####################################
# Start The Work
#####################################
okta_yes_code42_no = []
okta_yes_code42_yes = []
code42_users = []
code42_dict = {}
sdk = py42.sdk.from_local_account(code42_console,code42_api_account,code42_api_password, totp=None)
code42_all_users = sdk.users.get_all(active=True, email=None, org_uid=None, role_id=None, q=None)
code42_all_computers = sdk.devices.get_all(active=True,blocked=False,include_backup_usage=True)
for user in code42_all_users: 
    users = user['users']
    for username in users:
        local_username = username['username']
        code42_users.append(username['username'])
        code42_dict[username['userId']] = local_username

        
code42_computer_dict = {}
for devices in code42_all_computers:
    computers = devices['computers']
    for endpoints in computers:
        userId = endpoints['userId']
        hostname = endpoints['name']
        for computer_record in endpoints['backupUsage']:
#           print(computer_record)
            code42_computer_dict[code42_dict[userId]] = {'Hostname':hostname, 'lastConnected':computer_record['lastConnected'],'lastBackup':computer_record['lastBackup'],'lastCompletedBackup':computer_record['lastCompletedBackup'],'percentComplete':computer_record['percentComplete']}

for okta_user in okta_user_list:
    if okta_user not in code42_users and okta_user not in exclusions:
        okta_yes_code42_no.append(okta_user)
date=date.today()
with open(f'Code42_vs_Okta_Backup_Status_{date}.csv', mode='wt', encoding='utf-8') as report_output:
    writer = csv.writer(report_output)
    writer.writerow(('Email','Hostname', 'Last Connected','Last Backup Date', 'Last Completed Backup', 'Backup Percentage'))
    for key,computer in code42_computer_dict.items():
        writer.writerow([key,computer['Hostname'],computer['lastConnected'],computer['lastBackup'],computer['lastCompletedBackup'],computer['percentComplete']])
    writer.writerow([''])
    writer.writerow([''])
    writer.writerow([''])
    writer.writerow([''])
    writer.writerow(['No Code42'])
    for user in okta_yes_code42_no:
        writer.writerow([user])
    writer.writerow([f'Total Okta users without Code42 Accouts {len(okta_yes_code42_no)}'])
    