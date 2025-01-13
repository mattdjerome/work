#!/usr/bin/python3

from jamf_pro_sdk import JamfProClient, BasicAuthProvider
from jamf_pro_sdk.clients.pro_api.pagination import SortField
import json
from getpass import getpass
from local_credentials import jamf_user, jamf_password, jamf_hostname

client = JamfProClient(jamf_hostname, BasicAuthProvider(jamf_user, jamf_password))


response = client.pro_api.get_computer_inventory_v1()
for computers in response:
	try:
		print(computers.general.name,computers.userAndLocation.realname)
	except:
		print(computers)