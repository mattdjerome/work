#!/usr/bin/python3

from local_credentials import jamf_user, jamf_password, jamf_hostname
from jamf_pro_sdk import JamfProClient, BasicAuthProvider
import json

client = JamfProClient(jamf_hostname, BasicAuthProvider(jamf_user, jamf_password))


response = client.pro_api.get_computer_inventory_v1(sections = ["GENERAL","USER_AND_LOCATION","APPLICATIONS"], page_size=200)

apps = []
#apps = set()
computer_names = []
#print(response[0])
#### Gets a set (list without duplicates) of every app installed on a mac
for computers in response:
	for app_name in computers.applications:
		
		try:
			apps.append(app_name.name)
		except:
			continue
# Create an empty dictionary to store counts
count_dict = {}

# Iterate through the list
for app in apps:
	# Check if the value is already in the dictionary
	if app in count_dict:
		# If yes, increment its count
		count_dict[app] += 1
	else:
		# If not, add it to the dictionary with count 1
		count_dict[app] = 1
		
# Print the counts
for key, value in count_dict.items():
	print(f"{key},{value}")
computer_departments = []
for computer in response:
	try:
		user_and_location = computer.userAndLocation
		print(user_and_location.extensionAttributes)
		extension_attributes = user_and_location.extensionAttributes
		for attr in extension_attributes:
#			print(attr.name)
			#			if attr.name == 'LDAP-Department' and attr.value:
			department = attr.name
			computer_departments.append(department)
	except Exception as e:
		print(f"Error processing computer: {e}")
			
print("Departments associated with computers:")
print(computer_departments)