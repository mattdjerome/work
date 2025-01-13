#!/usr/bin/env python3

from local_credentials import jamf_user, jamf_password, jamf_hostname
from jamf_pro_sdk import JamfProClient, BasicAuthProvider
from jamf_pro_sdk.clients.pro_api.pagination import FilterField, SortField, FilterExpression
import datetime
import json
date = datetime.date.today() # Gets the current date
client = JamfProClient(jamf_hostname, BasicAuthProvider(jamf_user, jamf_password)) # Creates Jamf API authentication
response = client.pro_api.get_computer_inventory_v1(sections=["GENERAL", "CONFIGURATION_PROFILES"], page_size=200,sort_expression=SortField("id").asc()) # Requests computer data from Jamf Pro API
pci_group = client.classic_api.get_computer_group_by_id(411) # uses classic api to get the PCI group computer list group ID 411 is the 2024 PCI group
computer_list = []
for computer_name in pci_group.computers: # adds computers to a python list
	computer_list.append(computer_name.name)

