#!/bin/bash
#####
jUNPW="apiread:2023Holmes!"
basicAuth=$(echo -n $jUNPW | base64)
jURL="https://t300-1a.pro.jamf.training"

#Get Bearer Token with Basic Auth
bToken=$(curl -sk -X POST "$jURL/api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic $basicAuth" | awk '/token/{print $3}' | tr -d '"'',')

######


#Task 1
#curl -sk -H "Authorization: Bearer $bToken" -H "accept: application/xml" "$jURL/JSSResource/sites"

#Task 2
#curl -sk -H "Authorization: Bearer $bToken" -H "accept: application/xml" "$jURL/JSSResource/computergroups/id/1" | xmllint --format -

#Task 3
#curl -sk -H "Authorization: Bearer $bToken" -H "accept: application/xml" "$jURL/JSSResource/computers/id/100" | xmllint --format - > ~/Desktop/mycomp.txt

#Task 4
#curl -sk -H "Authorization: Bearer $bToken" -H "accept: application/xml" "$jURL/JSSResource/activationcode" | xmllint --xpath '/activation_code/code/text()' -