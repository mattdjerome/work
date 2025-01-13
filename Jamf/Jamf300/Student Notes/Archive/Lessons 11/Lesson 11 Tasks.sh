#!/bin/bash

#####
jUNPW="jamfadmin:2023Holmes!"
basicAuth=$(echo -n $jUNPW | base64)
jURL="https://t300-1a.pro.jamf.training"

#Get Bearer Token with Basic Auth
bToken=$(curl -sk -X POST "$jURL/api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic $basicAuth" | awk '/token/{print $3}' | tr -d '"'',')

######


#curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/sites/id/0" -X POST  -d "<site><name>Awesome</name></site>"


#curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/computers/id/100" -X PUT -d "<computer><general><site><name>Awesome</name></site></general></computer>"


#curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/mobiledevices/id/100" -X PUT -d "<mobile_device><general><site><name>Awesome</name></site></general></mobile_device>"

#curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/mobiledevices/id/100" -X PUT -d "<mobile_device><general><asset_tag>Mocha009</asset_tag></general><location><room>8675309</room></location></mobile_device>"

#curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/categories/id/0" -X POST -d "<category><name>LSUE</name><priority>2</priority></category>"

#curl -sk -H "Authorization: Bearer $bToken" "$jURL/JSSResource/sites/name/Staging" -X DELETE

#curl -sk -H "Authorization: Bearer $bToken" "$jURL/JSSResource/sites/name/Testing" -X DELETE

#curl -sk -H "Authorization: Bearer $bToken" -H "accept: text/xml" "$jURL/JSSResource/mobiledevicecommands/command/RestartDevice/id/100" -X POST


curl -sk -H "Authorization: Bearer $bToken" -H "accept: text/xml" "$jURL/JSSResource/mobiledevicecommands/command/UpdateInventory/id/100" -X POST