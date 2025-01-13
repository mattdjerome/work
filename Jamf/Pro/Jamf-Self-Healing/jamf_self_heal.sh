#!/bin/bash

# Redeploys the Jamf Management Framework 
# for enrolled device

jamfProURL=""
jamfProAPIUsername=""
jamfProAPIPassword=""
id=""

# Prompts for the URL, username, password and ID of the computer so no data is stored in the script and can be used for mulitple JAMF instances.
# Uses a while loop so if the field is left blank it keeps prompting.

while [ -z "$jamfProURL" ]; do
	jamfProURL=$(osascript -e 'set U to text returned of (display dialog "What is the URL of the JAMF Instance?" with icon posix file "/var/EC/ec_logo.png" buttons {"OK"} default button "OK" default answer "")')
done

while [ -z "$jamfProAPIUsername" ]; do
	jamfProAPIUsername=$(osascript -e 'set L to text returned of (display dialog "What is the username?" with icon posix file "/var/EC/ec_logo.png" buttons {"OK"} default button "OK" default answer "")')
done

while [ -z "$jamfProAPIPassword" ]; do
	jamfProAPIPassword=$(osascript -e 'set P to text returned of (display dialog "Please enter a password." default answer "" with icon POSIX file "/var/EC/ec_logo.png" buttons {"OK"} default button "OK" with hidden answer)')
done

while [ -z "$id" ]; do
	id=$(osascript -e 'set I to text returned of (display dialog "What is the JAMF Computer ID?" with icon posix file "/var/EC/ec_logo.png" buttons {"OK"} default button "OK" default answer "")')
done
# Jamf Pro API Credentials

# Token declarations
token=""
tokenExpirationEpoch="0"

#
##################################################
# Functions -- do not edit below here

# Get a bearer token for Jamf Pro API Authentication
getBearerToken(){
	# Encode credentials
	encodedCredentials=$( printf "${jamfProAPIUsername}:${jamfProAPIPassword}" | /usr/bin/iconv -t ISO-8859-1 | /usr/bin/base64 -i - )
	authToken=$(/usr/bin/curl -s -H "Authorization: Basic ${encodedCredentials}" "${jamfProURL}"/api/v1/auth/token -X POST)
	token=$(/bin/echo "${authToken}" | /usr/bin/plutil -extract token raw -)
	tokenExpiration=$(/bin/echo "${authToken}" | /usr/bin/plutil -extract expires raw - | /usr/bin/awk -F . '{print $1}')
	tokenExpirationEpoch=$(/bin/date -j -f "%Y-%m-%dT%T" "${tokenExpiration}" +"%s")
}

checkTokenExpiration() {
	nowEpochUTC=$(/bin/date -j -f "%Y-%m-%dT%T" "$(/bin/date -u +"%Y-%m-%dT%T")" +"%s")
	if [[ tokenExpirationEpoch -gt nowEpochUTC ]]
	then
		/bin/echo "Token valid until the following epoch time: " "${tokenExpirationEpoch}"
	else
		/bin/echo "No valid token available, getting new token"
		getBearerToken
	fi
}

# Invalidate the token when done
invalidateToken(){
	responseCode=$(/usr/bin/curl -w "%{http_code}" -H "Authorization: Bearer ${token}" ${jamfProURL}/api/v1/auth/invalidate-token -X POST -s -o /dev/null)
	if [[ ${responseCode} == 204 ]]
	then
		/bin/echo "Token successfully invalidated"
		token=""
		tokenExpirationEpoch="0"
	elif [[ ${responseCode} == 401 ]]
	then
		/bin/echo "Token already invalid"
	else
		/bin/echo "An unknown error occurred invalidating the token"
	fi
}

redeployFramework(){
	
	curl --request POST \
	--url ${jamfProURL}/api/v1/jamf-management-framework/redeploy/${id} \
	--header "Accept: application/json" \
	--header "Authorization: Bearer ${token}"
	

}

#
##################################################
# Script Work
#
#
# Calling all functions

checkTokenExpiration
redeployFramework 
checkTokenExpiration

# Gets the last enrollment date for the computer post re-enrollment
result=$(curl -X GET "${jamfProURL}/api/v1/computers-inventory-detail/${id}" -H  "accept: application/json" -H  "Authorization: Bearer ${token}" | grep "lastEnrolledDate" | awk '{print $3}')

#trims the value to remove the time of day in zulu to be just the date
trimmed=${result:1:10}

#uses IFS to get the year date and month
IFS='-' read year month day <<< $trimmed

#Formats teh date to be human readable and displays a dialog box with the last enrollment date pulled from the API
enrollment_date="${month}-${day}-${year}"
display_text="Last Enrollment occured at ${enrollment_date}"
osascript -e 'tell app "System Events" to display dialog "Last Enrollment for computer ID '$id': '$enrollment_date'" with icon posix file "/var/EC/ec_logo.png" buttons {"OK"} default button "OK"'

#invalidates the beare token so it can no longer be used
invalidateToken

exit 0