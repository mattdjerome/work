#!/bin/bash

jUNPW="api_user:abceasyas123"
basicAuth=$(echo -n $jUNPW | base64)
jURL="https://t300-11a.pro.jamf.training"

#Get Bearer Token with Basic Auth
bToken=$(curl -sk -X POST "$jURL/api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic $basicAuth" | awk '/token/{print $3}' | tr -d '"'',')

#Get unformatted list of xml for sites
curl -X GET "$jURL/JSSResource/sites" -H "accept: application/xml" -H "Authorization: Bearer $bToken"

curl -X GET "$jURL/JSSResource/sites" -H "accept: application/xml" -H "Authorization: Bearer $bToken"

curl -X GET "$jURL/JSSResource/computergroups/name/All%20Managed%20Clients" -H "accept: application/xml" -H "Authorization: Bearer $bToken" | xmllint --format -