'''
    Collection of useful JAMF functions
'''

import csv
import datetime
import os
import sys
import requests
from local_credentials import jamf_user, jamf_password, jamf_hostname


def get_all_computers():
    '''
    Fetches list of all computers in JAMF
    '''

    jamf_test_url = jamf_hostname + "/JSSResource/computers"
    headers = {'Accept': 'application/json', }
    response = requests.get(url=jamf_test_url, headers=headers, auth=(jamf_user, jamf_password))
    response_json = response.json()

    return response_json['computers']


def get_all_mobiledevices():
    '''
    Fetches list of all mobile devices in JAMF
    '''

    jamf_test_url = jamf_hostname + "/JSSResource/mobiledevices"
    headers = {'Accept': 'application/json', }
    response = requests.get(url=jamf_test_url, headers=headers, auth=(jamf_user, jamf_password))
    response_json = response.json()

    return response_json['mobile_devices']


def read_computers():
    '''
    Read preexisting computer list in csv form
    Meant for okta tables scripts
    '''

    cpu_dict = {}
    cpu_filename = "jamf_cpu_table.csv"

    try:
        mod_time = os.path.getmtime(cpu_filename)
        dt_mod = datetime.datetime.fromtimestamp(mod_time)
        now = datetime.datetime.now()
        mod_delta_seconds = (now - dt_mod).total_seconds() / 60

        if mod_delta_seconds > 60:
            print(f"!!!! WARNING: JAMF CPU TABLE {mod_delta_seconds:.0f} MINUTES OLD !!!!")
            print("Rerun jamf_grab_computers_mobiles.py")
            sys.exit()
        elif mod_delta_seconds > 15:
            print(f"!!!! WARNING: JAMF CPU TABLE {mod_delta_seconds:.0f} MINUTES OLD !!!!")

        with open(cpu_filename, mode='r') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                if line_count == 0:
                    line_count += 1
                else:
                    cpu_dict[row[0]] = {
                        'email_address': row[1],
                        'record_url': row[2],
                        'serial': row[3],
                        'okta_keychain': row[4]
                    }
    except IOError:
        sys.exit()

    return cpu_dict


def read_mobiles():
    '''
    Read preexisting mobile device list in csv form
    Meant for okta tables scripts
    '''

    mobile_dict = {}
    mobile_filename = "jamf_mobile_table.csv"

    try:
        mod_time = os.path.getmtime(mobile_filename)
        dt_mod = datetime.datetime.fromtimestamp(mod_time)
        now = datetime.datetime.now()
        mod_delta_seconds = (now - dt_mod).total_seconds() / 60

        if mod_delta_seconds > 60:
            print(f"!!!! WARNING: JAMF MOBILE TABLE {mod_delta_seconds:.0f} MINUTES OLD !!!!")
            print("Rerun jamf_grab_computers_mobiles.py")
            sys.exit()
        elif mod_delta_seconds > 15:
            print(f"!!!! WARNING: JAMF MOBILE TABLE {mod_delta_seconds:.0f} MINUTES OLD !!!!")

        with open(mobile_filename, mode='r') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                if line_count == 0:
                    line_count += 1
                else:
                    mobile_dict[row[0]] = {
                        'serial': row[3],
                        'email_address': row[1],
                        'device_record_url': row[2],
                        'phone_number': row[4],
                        'phone_number2': row[5],
                        'phone_number3': row[6]
                    }

    except IOError:
        print(mobile_filename, "is missing!")
        print("Run jamf_grab_computers_mobiles.py")
        sys.exit()

    return mobile_dict


def get_computer_info(specific_id):
    '''
    Fetches full record of specific computer
    '''

    jamf_test_url = jamf_hostname + "/JSSResource/computers/id/" + str(specific_id)
    headers = {'Accept': 'application/json', }
    response = requests.get(url=jamf_test_url, headers=headers, auth=(jamf_user, jamf_password))
    response_json = response.json()

    return response_json['computer']


def get_mobile_info(specific_id):
    '''
    Fetches full record of specific mobile device
    '''

    jamf_test_url = jamf_hostname + "/JSSResource/mobiledevices/id/" + str(specific_id)
    headers = {'Accept': 'application/json', }
    response = requests.get(url=jamf_test_url, headers=headers, auth=(jamf_user, jamf_password))
    response_json = response.json()

    return response_json['mobile_device']
