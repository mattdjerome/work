#!/usr/bin/env python3

# importing the module
import csv
from local_credentials import jamf_user, jamf_password, jamf_hostname
from jamf_pro_sdk import JamfProClient, BasicAuthProvider
from collections import defaultdict

snowDataFile = sys.argv[1] # CSV for ServiceNow data
jamfDataFile = sys.argv[2] # CSV for Jamf data

# creating dictreader object
jamfFile = csv.DictReader(jamfDataFile)
date = datetime.today().strftime('%m%d%Y-%H%M')
# creating empty list of serial numbers
serialNumbers = {}

for col in file:
	
# iterating over each row and append
# values to empty list
for col in file:
	if col['SNOW Status'] == "in use":
		user.update({col['Snow User'] : col['Computer Name']})
client = JamfProClient(jamf_hostname, BasicAuthProvider(jamf_user, jamf_password))


response = client.pro_api.get_computer_inventory_v1(sections=["GENERAL", "USER_AND_LOCATION"],
	page_size=1000)

data = defaultdict(list)
null_count = 0
for name in user:
	for computerData in response:
		if computerData.userAndLocation.realname == name:
				data[name].append(computerData.general.name)
	print(f'{name},{data[name]},{len(data[name])}')



	