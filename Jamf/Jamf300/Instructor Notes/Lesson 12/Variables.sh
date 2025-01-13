#!/bin/bash

#jURL="https://t300-1a.pro.jamf.training"
#echo "$jURL"

#man system_profiler

#system_profiler -listDataTypes
#system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}'



jUNPW="jamfadmin:2023Holmes!"
basicAuth=$(echo -n $jUNPW | base64)
jURL="https://t300-1a.pro.jamf.training"
macSerial=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}')

#Get Bearer Token with Basic Auth
bToken=$(curl -sk -X POST "$jURL/api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic $basicAuth" | awk '/token/{print $3}' | tr -d '"'',')

######
#Task 1: 
#curl -sk -H "Authorization: Bearer $bToken" -H "accept: text/xml" "$jURL/JSSResource/computers/serialnumber/$macSerial"| xmllint --format -

myCompID=$(curl -sk -H "Authorization: Bearer $bToken" -H "accept: text/xml" "$jURL/JSSResource/computers/serialnumber/$macSerial"| xmllint --xpath '/computer/general/id/text()' -)

curl -sk -H "Authorization: Bearer $bToken" -H "accept: text/xml" "$jURL/JSSResource/computers/id/$myCompID"| xmllint --xpath '/computer/general/name/text()' -
