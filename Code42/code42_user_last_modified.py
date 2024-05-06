#!/usr/local/bin/python3
import requests
import json
import csv
import datetime
from datetime import date
from dateutil.relativedelta import *
#from local_credentials import c42_clientid, c42_secret, c42_api_endpoint, c42_console_endpoint
def get_jwt_token():

    c42_test_url = "https://api.us2.code42.com/v1/oauth"
    headers = {'Accept': 'application/json', }
    c_id = 'key-622a3f1b-f2c0-4280-8ffb-69a2a7d5b8f1'
    secret = 'Jf%6xpWLgxGBM#zgMDsnb%ntb%N8pwGsp#xG7CQx'
    response = requests.post(url=c42_test_url, headers=headers, auth=(c_id, secret))
    response_json = response.json()

    return response_json['access_token']

def numOfDays(last_modified):
    modified_year = int(last_modified[0:4])
    modified_month = int(last_modified[5:7])
    modified_day = int(last_modified[8:10])
    print(modified_year,modified_month,modified_day)
    
    today = datetime.date.today()
    
    year = today.year
    month = today.month
    day = today.day
    
    print(year,month,day)
    
    
    last_modify_date = date(modified_year,modified_month,modified_day)
    today = date(year,month,day)
    print(numOfDays(last_modify_date))
    return (last_modify_date-today).days

    

    
def main():
    # insert code here.
    c42_test_url = "https://console.us2.code42.com"
    c_id = 'key-8ea7590b-36b1-47d3-8dda-8169b28fdaf3'
    secret = 'ggd%nnbmw3dC#gNngmJ64$7jPXLyrv#ytqmCXRVG'
        
    jwt_token = get_jwt_token()
    page = 1
    page_size = 500
    keep_going = True
#   date = datetime.date.today()
    with open(f'code42_user_last_modified{date}.csv', mode='wt', encoding='utf-8') as report_output:
        writer = csv.writer(report_output)
        writer.writerow(('UserName', 'modificationDate','Delta'))
        headers = {'cache-control': 'no-cache', 'Accept': 'application/json', 'authorization': 'Bearer ' + jwt_token}
        user_list_response = requests.get(url='https://api.us2.code42.com' + "/v1/users", headers=headers)
        user_list=user_list_response.json()
        while keep_going:
            user_list_response = requests.get(url=f'https://api.us2.code42.com/v1/users?page={page}&pageSize={page_size}', headers=headers)
            user_list = user_list_response.json()['users']
        
            for user in user_list:
                            
#           print(f"#{page:<3} users:{len(user_list)} status code:{user_list_response.status_code} url:{user_list_response.url}")
                if user['active'] is False:
                    last_modified=user['modificationDate']
                    modified_year = int(last_modified[0:4])
                    modified_month = int(last_modified[5:7])
                    modified_day = int(last_modified[8:10])
#                   print(modified_year,modified_month,modified_day)
                    
                    today = datetime.date.today()
                    
                    year = today.year
                    month = today.month
                    day = today.day
                    
#                   print(year,month,day)
                    
                    
                    last_modify_date = date(modified_year,modified_month,modified_day)
                    today = date(year,month,day)
                    delta = today - last_modify_date
                    print(delta.days)

#                   print(user['username'],user['modificationDate'],date_delta)
                   
                    writer.writerow((user['username'],user['modificationDate'],delta.days))
            if len(user_list) != page_size:
                keep_going = False
            else:
                page += 1
#   for user in user_list['users']:
#       print(user['username'], user['modificationDate'])
if __name__ == '__main__':
    main()