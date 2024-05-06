#!/usr/local/ec/bin/python3

import subprocess
import smtplib
from datetime import datetime
from email.message import EmailMessage
import requests
from 

#
# File a zendesk ticket

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


def file_ticket(errors,computername, computerdata):
    user='scanner@emersoncollective.com'
    password = '7qwc@QwaMRFo'
    smtpsrv = "smtp.office365.com"
    smtpserver = smtplib.SMTP(smtpsrv,587)
    msg = EmailMessage()
    msg['Subject'] = 'Compliance Alert'
    msg['From'] = 'scanner@emersoncollective.com'
    msg['To'] = 'mjerome@emersoncollective.com'
    smtpserver.starttls()
    smtpserver.login(user, password)
    smtpserver.send_message (msg)
    smtpserver.close()

### This is where the stuff happens###


COMPUTERS_URL = "https://emersoncollective.jamfcloud.com/JSSResource/computers"

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

code42_token = get_code42_token(code42, <#client_id#>, <#client_secret#>), <#code42_base_url#>)
code42_computers = 