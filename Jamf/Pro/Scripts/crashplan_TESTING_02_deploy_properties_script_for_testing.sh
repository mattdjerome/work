#!/bin/bash
#
# This script will pull the assigned user out of jamf and verify it against the local user information that my script found.

authInfo=api_user:pPxoziH59Y2j1DASIoa0n1
jamfURL="https://wjec-2a.cmdsec.com/JSSResource"
getInXML=("-H" "accept: text/xml")


get_local_info(){
  loggedInUser=$(who | grep console | grep -v '_mbsetupuser' | awk '{print $1}')  
  # loggedInUser=$("/usr/bin/stat" -f%Su "/dev/console")
  echo "$loggedInUser"
  loggedInUserHome=$("/usr/bin/dscl" . -read "/Users/$loggedInUser" NFSHomeDirectory | "/usr/bin/awk" '{print $NF}')
  userFirstName=$(id -F "$loggedInUser"| awk '{print $1}')
  userLastName=$(id -F "$loggedInUser"| awk '{print $2}')
  deviceSerialNumber=$(system_profiler SPHardwareDataType | grep 'Serial Number (system)' | awk '{print $NF}')
  # deviceSerialNumber="C02XL0ANJGH5"
}

get_jamf_info(){
  fullComputerRecord=$(curl -sku $authInfo "${getInXML[@]}" "$jamfURL/computers/match/$deviceSerialNumber")

  jamfUserName=$(echo "$fullComputerRecord" | xmllint --xpath 'string(/computers/computer/username)' - | awk '{print $1}')
  # jamfUserName="jesse@emersoncollective.com"
  # check if local user name is email address assigned to computer in jamf
  firstNameMatch=$(echo "$jamfUserName" | grep -m 1 -iE "$userFirstName@")
  lastNameMatch=$(echo "$jamfUserName" | grep -m 1 -iE ".*$userLastName@")
}


get_local_info
get_jamf_info

# Check if jamfUserName is assigned, and if it contains the logged in user's first or last name
if [[ -z $jamfUserName ]]; then
  echo "### no user assigned in jamf for computer"
  exit 1
elif [[ -n $firstNameMatch ]] || [[ -n $lastNameMatch ]]; then
  echo "### found user match"
  echo "C42user$jamfUserName"
  echo "C42home=$loggedInUserHome"
  exit 0
else
  echo "### No match found, exiting without changes"
  echo "jamfUser:$jamfUserName"
  echo "loggedInUser:$loggedInUser"
  echo "$userFirstName:$userLastName"
  exit 1
fi

