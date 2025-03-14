#!/usr/bin/env python3

# importing the module
import csv
import sys
from pandas import *
from csv import DictReader

snowDataFile = sys.argv[1] #CSV for ServiceNow data
jamfDataFile = sys.argv[2]  # CSV for Jamf data

# Initialize jamfComputerData as a dictionary
jamfComputerData = {}
# Make a list of Jamf Serials to process
data = read_csv(jamfDataFile)
jamfserialNumbers = data['Serial Number'].tolist()
with open(jamfDataFile, 'r', encoding='unicode_escape') as jamfData:
    for line in csv.DictReader(jamfData):
        # Assign email address to the computer name in the dictionary
        jamfComputerData[line['Serial Number']] = line['Email Address']

# Initialize ServiceNowData as a dictionary
snowComputerData = {}
with open(snowDataFile, 'r', encoding='unicode_escape') as snowData:
    for line in csv.DictReader(snowData):
        # Assign email address to the computer name in the dictionary
        snowComputerData[line['serial_number']] = line['assigned_to.email']
count=0
for serial in jamfserialNumbers:
    try:
        if jamfComputerData[serial].lower() != snowComputerData[serial].lower():
            count = count + 1
            print(count,serial, jamfComputerData[serial].lower(), snowComputerData[serial].lower())
            
            
    except Exception:
        continue
