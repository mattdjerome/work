#!/bin/sh
# This script uses the Jamf Pro API to get a Bearer Authentication Token and then adds a computer to a Static Group.  
#   In this case it could be the computer the script is run on if you uncomment the particular line.  I actually set the computer name for testing to a specific name
# Adapted from https://derflounder.wordpress.com/2022/01/05/updated-script-for-obtaining-checking-and-renewing-bearer-tokens-for-the-classic-and-jamf-pro-apis/ - not all functions in Rich's example are used as this is a very short access to the API
# Also help from Steve Dagley in https://community.jamf.com/t5/jamf-pro/bearer-token-api-and-adding-computer-to-static-group/td-p/261269
#   and https://community.jamf.com/t5/jamf-pro/script-to-add-computer-to-static-group/m-p/198738
# 2022-03-17 David London

# Find/Set the computer name.  I'm manually setting it here for testing.

# 2025-02-14 mattdjerome modified to use input variables as well as reading from a CSV

# My test static group is called TestGroup and has ID of 3.  Set these to whatever you need
GroupID="$1"
GroupName="$2"

# Explicitly set initial value for the api_token variable to null:
api_token=""

# Explicitly set initial value for the token_expiration variable to null:
token_expiration=""

# Set the Jamf Pro URL here if you want it hardcoded.
jamfpro_url="$3"

# Set the username here if you want it hardcoded.
jamfpro_user="$4"

# Set the password here if you want it hardcoded.
jamfpro_password='$5'	


# Remove the trailing slash from the Jamf Pro URL if needed.
jamfpro_url=${jamfpro_url%%/}

GetJamfProAPIToken() {
    # This function uses Basic Authentication to get a new bearer token for API authentication.
    # Use user account's username and password credentials with Basic Authorization to request a bearer token.

    if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
        api_token=$(/usr/bin/curl -X POST --silent -u "${jamfpro_user}:${jamfpro_password}" "${jamfpro_url}/api/v1/auth/token" | python -c 'import sys, json; print json.load(sys.stdin)["token"]')
    else
        api_token=$(/usr/bin/curl -X POST --silent -u "${jamfpro_user}:${jamfpro_password}" "${jamfpro_url}/api/v1/auth/token" | plutil -extract token raw -)
    fi
}

APITokenValidCheck() {
    # Verify that API authentication is using a valid token by running an API command
    # which displays the authorization details associated with the current API user. 
    # The API call will only return the HTTP status code.

    api_authentication_check=$(/usr/bin/curl --write-out %{http_code} --silent --output /dev/null "${jamfpro_url}/api/v1/auth" --request GET --header "Authorization: Bearer ${api_token}")
}

InvalidateToken() {
    # Verify that API authentication is using a valid token by running an API command
    # which displays the authorization details associated with the current API user. 
    # The API call will only return the HTTP status code.

    APITokenValidCheck

    # If the api_authentication_check has a value of 200, that means that the current
    # bearer token is valid and can be used to authenticate an API call.

    if [[ ${api_authentication_check} == 200 ]]; then

        # If the current bearer token is valid, an API call is sent to invalidate the token.

        authToken=$(/usr/bin/curl "${jamfpro_url}/api/v1/auth/invalidate-token" --silent  --header "Authorization: Bearer ${api_token}" -X POST)
      
        # Explicitly set value for the api_token variable to null.
        api_token=""
    fi
}

GetJamfProAPIToken

apiURL="JSSResource/computergroups/id/${GroupID}"
csv_file='/Users/mjerome/Downloads/644 Computers in App - ZScaler - Installed(Phase 1).csv'
IFS=','  # Set the delimiter to comma

column_1_array=()

while IFS=',' read -r -a fields; do
    column_1_array+=("${fields[0]}") # Add the first field to the array
done < "$csv_file"

# Print the array elements (optional)
for ComputerName in "${column_1_array[@]}"; do
    echo "$ComputerName"
    apiData="<computer_group><id>${GroupID}</id><name>${GroupName}</name><computer_additions><computer><name>$ComputerName</name></computer></computer_additions></computer_group>"
    curl -s \
    --header "Authorization: Bearer ${api_token}" --header "Content-Type: text/xml" \
    --url "${jamfpro_url}/${apiURL}" \
    --data "${apiData}" \
    --request PUT > /dev/null
done

InvalidateToken

exit 0