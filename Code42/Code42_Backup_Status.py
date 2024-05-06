#!/usr/bin/env python3

import py42.sdk
import json
from local_credentials import code42_base_url as c42_url, code42_key as c42_key, code42_secret as c42_secret
from datetime import date
import csv


def code42_data():
sdk = py42.sdk.from_local_account("https://console.us2.code42.com","app.crashplan@emersoncollective.com","rH8vh@Z!73Jk", totp=None)
#all_users = sdk.users.get_all(active=None, email=None, org_uid=None, role_id=None, q=None)
for user in all_users: 
    users = user['users']
    for username in users:
        local_user = username['username']
        print(local_user)
count = 0
all_computers = sdk.devices.get_all(active=True,blocked=False,include_backup_usage=True)

for devices in all_computers:
    computers = devices['computers']
    for endpoints in computers:
        for computer_record in endpoints['backupUsage']:
            print(endpoints['name'], computer_record['lastBackup'] ,computer_record['lastCompletedBackup'],computer_record['percentComplete'])
date=date.today()

with open(f'Code42_Backup_Status_{date}.csv', mode='wt', encoding='utf-8') as report_output:
    writer = csv.writer(report_output)
    writer.writerow(('Hostname', 'Last Connected','Last Backup Date', 'Last Completed Backup', 'Backup Percentage'))
    for devices in all_computers:
        computers = devices['computers']
        for endpoints in computers:
            for computer_record in endpoints['backupUsage']:
                writer.writerow([endpoints['name'], computer_record['lastConnected'], computer_record['lastBackup'], computer_record['lastCompletedBackup'], computer_record['percentComplete']])