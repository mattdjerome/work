#!/usr/bin/env python3

import csv
import sys
from datetime import date
from jamf_pro_sdk import JamfProClient, ApiClientCredentialsProvider
from jamf_pro_sdk.models.pro.computers import Computer



# --- Read serial numbers from CSV ---
def read_serial_numbers(file_path):
    serial_numbers = []
    try:
        with open(file_path, newline='') as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                if row:
                    serial_numbers.append(row[0].strip())
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        sys.exit(1)
    return serial_numbers


# --- Define Variables ---
csv_file = sys.argv[1]
api_url = sys.argv[2]
client_id = sys.argv[3]
client_secret = sys.argv[4]

# --- Retrieve Jamf API Token ---
client = JamfProClient(
    server=api_url,
    credentials=ApiClientCredentialsProvider(client_id, client_secret)
)


# --- Get List of Jamf Computers ---
jamfComputers = []
response = client.pro_api.get_computer_inventory_v1(sections=['HARDWARE'])
for computers in response:
    jamfComputers.append(computers.hardware.serialNumber)
    
# --- List of Qualys Serials ---

qualysSerials = read_serial_numbers(csv_file)

# --- Check if Qualys serial is in Jamf list ---

notInJamf = []
for serialNumber in qualysSerials:
    if serialNumber not in jamfComputers:
        notInJamf.append(serialNumber)


# --- Output to CSV ---

date=date.today()

with open(f'In_Qualys_Not_In_Jamf_{date}.csv', mode='wt', encoding='utf-8') as report_output:
    writer = csv.writer(report_output)
    for devices in notInJamf:
        writer.writerow([devices])