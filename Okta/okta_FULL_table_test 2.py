#!/usr/local/bin/python3

import csv
import datetime
import os
import requests
import tqdm
import jamf_utilities

from local_credentials import jamf_user, jamf_password, jamf_hostname, okta_api_endpoint, okta_api_key

def main():
    master_version = "0.0b2"
    employment_table = {}
    enrollment_table = {}

    computer_dict = jamf_utilities.read_computers()
    mobile_dict = jamf_utilities.read_mobiles()

#     okta_api_key = '00Aldg4w7LvNo0ALFIFLqjrgItEjIT50ltKKbqPZ13'
    okta_user_table = {}
    okta_headers = {'Content-Type':'application/json', 'Accept':'application/json', 'Authorization':'SSWS ' + okta_api_key}
    next_page = True
#     next_url = okta_api_endpoint + '/api/v1/users'
    next_url = f'https://emersoncollective-admin.okta.com/api/v1/users'


    cba_enrolled = 0
    while next_page:
#         print(next_url)
        response = requests.get(next_url, headers=okta_headers)
        response_json = response.json()
        print(response.status_code)

        for user in response_json:

            if 'userType' not in user['profile'].keys():
                user_type = None
            else:
                user_type = user['profile']['userType']

                if user_type not in employment_table.keys():
                    employment_table[user_type] = 1
                else:
                    employment_table[user_type] += 1

            if 'cba_required' in user['profile'].keys():
                cba_required = user['profile']['cba_required']
                if cba_required:
                    cba_enrolled += 1
            else:
                cba_required = None
#                         cba_required = 'undefined'

            try:
                fullname = user['profile']['displayName']
            except KeyError:
                fullname = None

            if not fullname:
#                         print('Pop')
                try:
                    fullname = ' '.join([user['profile']['firstName'], user['profile']['lastName']])
#                             print(fullname)
                except:
                    pass

            try:
                team = user['profile']['team']
            except KeyError:
                team = None

            try:
                org = user['profile']['organization']
            except KeyError:
                org = None

            possible_emails = []

            if 'ecProxyAddress' in user['profile'].keys():
                for p_email in user['profile']['ecProxyAddress']:
                    p_email = p_email.lower().split('smtp:')[1]
                    possible_emails.append(p_email)

            try:
                possible_emails.append(user['profile']['login'])
            except KeyError:
                email = None

            try:
                possible_emails.append(user['profile']['email'])
            except KeyError:
                pass

            try:
                possible_emails.append(user['profile']['secondEmail'])
            except KeyError:
                pass

            # may want to get this from jamf instead.
            try:
                phone = user['profile']['mobilePhone']
            except KeyError:
                phone = None

            possible_emails = [x for x in possible_emails if x]
            lowered_emails = [x.lower() for x in possible_emails if x]

            try:
                user_title = user['profile']['title']

                if 'director' in user_title.lower():
                    pass
                elif 'md' in user_title.lower():
                    pass
                else:
                    user_title = None
            except KeyError:
                user_title = None

            okta_user_table[user['id']] = {
                'full_name' : fullname,
                'org' : org,
                'team' : team,
                'email' : set(lowered_emails),
                'phone' : phone,
                'cba_required' : cba_required,
                'title' : user_title,
                'user_type' : user_type
            }

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


    print("full user table size:", len(okta_user_table))

    # get list of computers
    all_computers = jamf_utilities.get_all_computers()
    print("      # of computers:", len(all_computers))

    # get list of devices (iphones)
    all_mobiledevices = jamf_utilities.get_all_mobiledevices()
    print(" # of mobile devices:", len(all_mobiledevices))

    # parse list of phones
        # search list for matching email
            # save url of phone record
            # save phone number

    print("Output CSV...")
    timenow = datetime.datetime.now()
    filename = "okta+365+table_FULL_TEST_" + str(timenow) + ".csv"
    fieldnames = ['Full Name', 'Staff Member', 'Title', 'Org', 'Team', 'CBA Active', 'Computer Record', 'Okta Keychain Installed', 'Mac Serial Number', 'iPhone Record', 'Phone Number', 'User Type']


    assigned_mobile = 0
    assigned_mac = 0
    with open(filename, mode='w') as tablefile:
        writer = csv.DictWriter(tablefile, delimiter=',', fieldnames=fieldnames)
        writer.writeheader()

        for key in okta_user_table:
            current_id = key
            current_name = okta_user_table[current_id]['full_name']

            # pretty the email column?!?
            f_email = ''
            for e_item in okta_user_table[current_id]['email']:
                f_email += e_item + '\n'

            current_email = f_email

#                 current_email = okta_user_table[current_id]['email']
            current_phone = okta_user_table[current_id]['phone']
            current_title = okta_user_table[current_id]['title']
            current_org = okta_user_table[current_id]['org']
            current_team = okta_user_table[current_id]['team']
            current_cba_active = okta_user_table[current_id]['cba_required']
            current_user_type = okta_user_table[current_id]['user_type']

            if current_user_type not in employment_table.keys():
                employment_table[current_user_type] = 1
            else:
                employment_table[current_user_type] += 1

            # restore sanity to participation percentage
            if current_cba_active:
                if current_user_type not in enrollment_table.keys():
                    enrollment_table[current_user_type] = 1
                else:
                    enrollment_table[current_user_type] += 1

            current_iphone_urls_table = ''
            current_iphone_numbers_table = ''
            for _, value in mobile_dict.items():
                if value['email_address'] in okta_user_table[current_id]['email']:
                    assigned_mobile += 1
                    current_iphone_numbers_table += value['phone_number'] + '\n'
                    current_iphone_urls_table += value['device_record_url'] + '\n'

            current_iphone_numbers_table = current_iphone_numbers_table[:-1]
            current_iphone_urls_table = current_iphone_urls_table[:-1]

            current_computer_urls_table = ''
            current_computer_serial_table = ''
            current_computer_keychain_table = ''
            for _, value in computer_dict.items():
                if value['email_address'] in okta_user_table[current_id]['email']:
                    assigned_mac += 1
                    current_computer_urls_table += value['record_url'] + '\n'
                    current_computer_serial_table += value['serial'] + '\n'
                    current_computer_keychain_table += str(value['okta_keychain']) + '\n'

            current_computer_urls_table = current_computer_urls_table[:-1]
            current_computer_serial_table = current_computer_serial_table[:-1]
            current_computer_keychain_table = current_computer_keychain_table[:-1]

            writer.writerow({'Full Name':current_name, 'CBA Active':current_cba_active, 'Title':current_title, 'Org':current_org, 'Team':current_team, 'Staff Member':current_email, 'Computer Record': current_computer_urls_table, 'Okta Keychain Installed': current_computer_keychain_table, 'Mac Serial Number': current_computer_serial_table, 'iPhone Record':current_iphone_urls_table, 'Phone Number': current_iphone_numbers_table, 'User Type': current_user_type})

        print()
        eligible_count = 0
        enrollment_count = 0
        print("Role table:")
        for key, value in employment_table.items():
            print(f"  {value:4} {key}")
            if key == "Full Time":
                eligible_count += value
            elif key == "Intern":
                eligible_count += value
            elif key == "Full Time - Short Term Employee":
                eligible_count += value

        print()
        print("Enrollment role table:")
        for key, value in enrollment_table.items():
            print(f"  {value:4} {key}")
            if key == "Full Time":
                enrollment_count += value
            elif key == "Intern":
                enrollment_count += value
            elif key == "Full Time - Short Term Employee":
                enrollment_count += value

        print()
        print("Assigned Mobile devices: " + str(assigned_mobile))
        print(" Assigned MacOS devices: " + str(assigned_mac))
        print()
        print("Active Enrolled CBA Users: " + str(enrollment_count))
        print(f"                 Eligible: {eligible_count} {enrollment_count/eligible_count:.2%}")

if __name__ == '__main__':
    main()


# {
#     "id": "00u10yg7vsv3iAcfm2p7",
#     "status": "ACTIVE",
#     "created": "2018-04-20T15:00:54.000Z",
#     "activated": "2018-06-27T19:34:52.000Z",
#     "statusChanged": "2018-07-25T22:24:03.000Z",
#     "lastLogin": "2022-02-08T06:17:28.000Z",
#     "lastUpdated": "2022-01-31T22:49:46.000Z",
#     "passwordChanged": "2018-11-15T23:02:07.000Z",
#     "type": {
#         "id": "otyne2n9axV8vZxcq2p6"
#     },
#     "profile": {
#         "lastName": "Bromley",
#         "zipCode": "90232",
#         "hireDate": "11/27/17",
#         "manager": "Steve McDermid",
#         "city": "Los Angeles",
#         "displayName": "Scott Bromley",
#         "secondEmail": "scottbromley@gmail.com",
#         "managerId": "steve@emersoncollective.com",
#         "team": "Media",
#         "title": "Senior Director, Venture Investing (Media)",
#         "login": "scott@emersoncollective.com",
#         "associateId": "QPS9HTPPE",
#         "emergencyPhoneNumber": "917-328-7228",
#         "firstName": "Scott",
#         "mobilePhone": "917-328-7228",
#         "ecProxyAddress": [
#             "smtp:scott.bromley@emersoncollective.org",
#             "SMTP:scott@emersoncollective.com",
#             "smtp:scott.bromley@emersoncollective.com"
#         ],
#         "streetAddress": "8522 National Blvd",
#         "o365Provisioned": true,
#         "organization": "Emerson Collective",
#         "location": "LA | Main Office",
#         "userType": "Full Time",
#         "state": "CA",
#         "department": "Investment",
#         "email": "scott@emersoncollective.com"
#     },
#     "credentials": {
#         "password": {},
#         "recovery_question": {
#             "question": "What is the name of your first stuffed animal?"
#         },
#         "provider": {
#             "type": "OKTA",
#             "name": "OKTA"
#         }
#     },
#     "_links": {
#         "self": {
#             "href": "https://emersoncollective.okta.com/api/v1/users/00u10yg7vsv3iAcfm2p7"
#         }
#     }
# }
