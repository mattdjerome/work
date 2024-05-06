#!/usr/local/ec/bin/python3

import csv
import subprocess
import requests
import tqdm
from local_credentials import jamf_user, jamf_password, jamf_hostname

def get_all_computers():
    jamf_test_url = jamf_hostname + "/JSSResource/computers"
    headers = {'Accept': 'application/json', }
    response = requests.get(url=jamf_test_url, headers=headers, auth=(jamf_user, jamf_password))
    response_json = response.json()

    return response_json['computers']

def get_all_mobiledevices():
    jamf_test_url = jamf_hostname + "/JSSResource/mobiledevices"
    headers = {'Accept': 'application/json', }
    response = requests.get(url=jamf_test_url, headers=headers, auth=(jamf_user, jamf_password))
    response_json = response.json()

    return response_json['mobile_devices']

def get_full_info(specific_id):

    # success = False
    # fail_count = 0
    #
    # check fail_count and success
    # try
    # ...
    #   break?
    # except json.decoder.JSONDecodeError:
    # except requests.ERROR:
    # else:
    #  success = True

    jamf_test_url = jamf_hostname + "/JSSResource/computers/id/" + str(specific_id)
    headers = {'Accept': 'application/json', }
    response = requests.get(url=jamf_test_url, headers=headers, auth=(jamf_user, jamf_password))
    response_json = response.json()

    return response_json['computer']

def get_mobile_info(specific_id):
    jamf_test_url = jamf_hostname + "/JSSResource/mobiledevices/id/" + str(specific_id)
    headers = {'Accept': 'application/json', }
    response = requests.get(url=jamf_test_url, headers=headers, auth=(jamf_user, jamf_password))
    response_json = response.json()

#     for item in response_json['mobile_device']['configuration_profiles']:
#         if item['display_name'] == 'MDM Profile':
#             print(item['identifier'])

    return response_json['mobile_device']

def main():
    master_version = "0.0b1"

    # additional columns
    # FDA for Code42
    # Current Backup Percentage
    # Last Backup Date
    # Extra DLP data points that mean healthy
    # Selected Amt of backup data
    # Total data for computer

    cpu_filename = "jamf_cpu_table.csv"
    cpu_fields = ['udid', 'email', 'jamf url', 'serial', 'okta keychain']

    mobile_filename = "jamf_mobile_table.csv"
    mobile_fields = ['udid', 'email', 'jamf url', 'serial', 'Phone1', 'Phone2', 'Phone3']

    # get list of computers
    all_computers = get_all_computers()
    print("      # of computers:", len(all_computers))

    # get list of devices (iphones)
    all_mobiledevices = get_all_mobiledevices()
    print(" # of mobile devices:", len(all_mobiledevices))
    print()

    # parse list of phones
        # search list for matching email
            # save url of phone record
            # save phone number

    mobile_dict = {}
    mobile_count = len(all_mobiledevices)

    print()
    print('Fetching individual records... ')
    print(' Mobile... ')
    check_udid = 0
    with open(mobile_filename, mode='w') as tablefile:
        writer = csv.DictWriter(tablefile, delimiter=',', fieldnames=mobile_fields)
        writer.writeheader()

        for tick in tqdm.tqdm(range(mobile_count)):
            item = all_mobiledevices[tick]
            specific_mobile = get_mobile_info(item['id'])

            mobile_record_url = jamf_hostname + '/mobileDevices.html?id=' + str(specific_mobile['general']['id']) + '&o=r'
            phone_number = specific_mobile['general']['phone_number']
            phone_number2 = specific_mobile['location']['phone_number']
            phone_number3 = specific_mobile['location']['phone']

            if not specific_mobile['location']['email_address']:
                if not specific_mobile['location']['username']:
                    device_email = None
                else:
                    device_email = specific_mobile['location']['username'].lower()
            else:
                device_email = specific_mobile['location']['email_address'].lower()

            writer.writerow({'udid':specific_mobile['general']['udid'], 
                'email':device_email, 
                'jamf url':mobile_record_url, 
                'serial':specific_mobile['general']['serial_number'],
                'Phone1':phone_number,
                'Phone2':phone_number2,
                'Phone3':phone_number3,
            })

    print(' Computers... ')
    computer_dict = {}
    computer_count = len(all_computers)
    
    with open(cpu_filename, mode='w') as tablefile:
        writer = csv.DictWriter(tablefile, delimiter=',', fieldnames=cpu_fields)
        writer.writeheader()

        for tick in tqdm.tqdm(range(computer_count)):
            item = all_computers[tick]
            specific_computer = get_full_info(item['id'])

            cpu_record_url = jamf_hostname + '/computers.html?id=' + str(specific_computer['general']['id']) + '&o=r'
            cpu_serial = specific_computer['general']['serial_number']

            # THIS ISN'T WORKING!!!!
            okta_keychain = None
            for ea in specific_computer['extension_attributes']:
                if ea['id'] == 218:
                    if "Installed".lower() in ea['value'].lower():
                        okta_keychain = "True".upper()
                    else:
                        okta_keychain = "False".upper()

                    break

            if not specific_computer['location']['email_address']:
                if not specific_computer['location']['username']:
                    device_email = None
                else:
                    device_email = specific_computer['location']['username'].lower()
            else:
                device_email = specific_computer['location']['email_address'].lower()

            writer.writerow({'udid':specific_computer['general']['udid'], 
                'email' : device_email,
                'jamf url' : cpu_record_url,
                'serial' : cpu_serial,
                'okta keychain' : okta_keychain
            })

    subprocess.run(['/usr/bin/say', "'grab complete'"])


if __name__ == '__main__':
    main()
