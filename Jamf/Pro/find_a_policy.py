import requests
import json
from local_credentials import jamf_user, jamf_password, jamf_hostname

def get_uapi_token(jamf_user, jamf_password, jamf_hostname):
    try:
        jamf_test_url = jamf_hostname + "/api/v1/auth/token"
        header = {'Accept': 'application/json'}
        record = requests.post(url=jamf_test_url, headers=header, auth=(jamf_user, jamf_password))
        record.raise_for_status()  # Raise an HTTPError for bad responses
        response_json = record.json()
        return response_json['token']
    except requests.exceptions.RequestException as e:
        print(f"HTTP error occurred: {e}")
    except json.JSONDecodeError as e:
        print(f"JSON decode error occurred: {e}")
    except KeyError:
        print("Key 'token' not found in the response")
    return None

token = get_uapi_token(jamf_user, jamf_password, jamf_hostname)

if token:
    # Create the URL
    url = "https://fanatics.jamfcloud.com/JSSResource/policies"
    
    # Set the headers
    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/json"
    }
    
    try:
        # Make the request
        response = requests.get(url, headers=headers)
        response.raise_for_status()  # Raise an HTTPError for bad responses
        policy_results = response.json()
    except requests.exceptions.RequestException as e:
        print(f"HTTP error occurred: {e}")
    except json.JSONDecodeError as e:
        print(f"JSON decode error occurred: {e}")
else:
    print("Failed to retrieve the token.")
id_numbers=[]
self_service_names = {}

for policy in policy_results['policies']:
    id_numbers.append(policy['id'])
for ids in id_numbers:
    url = f"https://fanatics.jamfcloud.com/JSSResource/policies/id/{ids}"
    try:
    # Make the request
        response = requests.get(url, headers=headers)
        response.raise_for_status()  # Raise an HTTPError for bad responses
        policy_results = response.json()
        self_service_names[ids] = policy_results['policy']['self_service']['self_service_display_name']
    except requests.exceptions.RequestException as e:
        print(f"HTTP error occurred: {e}")
    except json.JSONDecodeError as e:
        print(f"JSON decode error occurred: {e}")
print(self_service_names)
#print(policy_results['policy']['self_service']['self_service_display_name'])