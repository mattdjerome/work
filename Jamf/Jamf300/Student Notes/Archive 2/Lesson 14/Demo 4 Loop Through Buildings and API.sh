#!/bin/bash
jUNPW="jamfadmin:2023Holmes!"
basicAuth=$(echo -n $jUNPW | base64)
jURL="https://t300-1a.pro.jamf.training"

#Get Bearer Token with Basic Auth
bToken=$(curl -sk -X POST "$jURL/api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic $basicAuth" | awk '/token/{print $3}' | tr -d '"'',')

for bldg in "Broussard" "Lafayette" "Youngsville";do

	curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/buildings/id/0" -X POST -d "<building><name>$bldg</name></building>"
done