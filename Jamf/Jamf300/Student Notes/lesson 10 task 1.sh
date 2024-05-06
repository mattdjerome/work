#!/bin/bash

jUNPW="api_user:abceasyas123"
basicAuth=$(echo -n $jUNPW | base64)
jURL="https://t300-11a.pro.jamf.training"

#Get Bearer Token with Basic Auth
bToken=$(curl -sk -X POST "$jURL/api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic $basicAuth" | awk '/token/{print $3}' | tr -d '"'',')

###Create a category,-d (data) is required, also change application to content-type, use 0 for id so it uses the next available

#curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/categories/id/0" -X POST -d "<category><name>Update</name><priority>2</priority></category>"

###Change the record of a computer by computer ID
curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/computers/id/44" -X PUT -d "<computer><general><site><name>Testing</name></site></general></computer>"

###Change the record of a mobile device by computer ID
curl -k -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/mobiledevices/id/19" -X PUT -d "<mobile_device><general><site><name>Production</name></site></general></mobile_device>"

#Update Inventory on a mobile device
curl -sk -H "Authorization: Bearer $bToken" -H "accept: text/xml" "$jURL/JSSResource/mobiledevicecommands/command/UpdateInventory/id/101" -X POST