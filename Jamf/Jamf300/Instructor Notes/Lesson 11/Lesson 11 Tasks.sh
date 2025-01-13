#!/bin/bash

#####
jUNPW="jamfadmin:2023Holmes!"
basicAuth=$(echo -n $jUNPW | base64)
jURL="https://t300-1a.pro.jamf.training"

#Get Bearer Token with Basic Auth
bToken=$(curl -sk -X POST "$jURL/api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic $basicAuth" | awk '/token/{print $3}' | tr -d '"'',')

######
#Task 1: 
curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/categories/id/0" -X POST -d "<category><name>Updates</name></category>"

#Task 2: 
curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/computers/id/44" -X PUT -d "<computer><general><site><name>Testing</name></site></general></computer>"

#task 3
curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/mobiledevices/id/19" -X PUT -d "<mobile_device><general><site><name>Production</name></site></general></mobile_device>"
#Task4
curl -sk -H "Authorization: Bearer $bToken" -H "accept: text/xml" "$jURL/JSSResource/mobiledevicecommands/command/UpdateInventory/id/100" -X POST