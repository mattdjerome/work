#!/usr/local/ec/bin/python3

import csv
import jamf_pro_sdk
import requests
import json
from local_credentials import jamf_user, jamf_password, jamf_hostname
from jamf_pro_sdk import JamfProClient, BasicAuthProvider
from jamf_pro_sdk.clients.pro_api.pagination import FilterField, SortField
client = JamfProClient(
    server="emersoncollective.jamfcloud.com",
    credentials=BasicAuthProvider(jamf_user,jamf_password)
)
response = client.pro_api.get_computer_inventory_v1(page_size=100, sort_expression=SortField("id").asc())

for item in response:
    print(item,'\n')