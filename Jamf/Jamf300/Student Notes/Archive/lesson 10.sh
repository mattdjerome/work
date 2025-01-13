#!/bin/bash


jUNPW="api_user:abceasyas123"
basicAuth=$(echo -n $jUNPW | base64)
jURL="https://t300-11a.pro.jamf.training"

#Get Bearer Token with Basic Auth
bToken=$(curl -sk -X POST "$jURL/api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic $basicAuth" | awk '/token/{print $3}' | tr -d '"'',')

#Get unformatted list of xml for sites
#curl -X GET "$jURL/JSSResource/sites" -H "accept: application/xml" -H "Authorization: Bearer $bToken"

### Add a Site, -d (data) is required, also change application to content-type, use 0 for id so it uses the next available
#curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/sites/id/0" -X PUT -d "<site><name>Awesome</name></site>"


###Change the record of a computer by computer ID
#curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/computers/id/100" -X PUT -d "<computer><general><site><name>Awesome</name></site></general></computer>"

###Change the record of a mobile device by computer ID
#curl -k -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/mobiledevices/id/101" -X PUT -d "<mobile_device><general><site><name>Awesome</name></site></general></mobile_device>"

###Create a category,-d (data) is required, also change application to content-type, use 0 for id so it uses the next available

#curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/categories/id/0" -X POST -d "<category><name>LSU</name><priority>2</priority></category>"

#Example to delete a site, this will fail b/c there's stuff associated with the site.
#curl -sk -H "Authorization: Bearer $bToken" "$jURL/JSSResource/sites/name/Testing" -X DELETE


# Get all the mobile device commands data
curl -sk -H "Authorization: Bearer $bToken" -H "accept: application/xml"-X GET "$jURL/JSSResource/mobiledevicecommands" | xmllint --format -

#Restart a mobile device
#curl -sk -H "Authorization: Bearer $bToken" -H "accept: text/xml" "$jURL/JSSResource/mobiledevicecommands/command/RestartDevice/id/101" -X POST

#Update Inventory on a mobile device
curl -sk -H "Authorization: Bearer $bToken" -H "accept: text/xml" "$jURL/JSSResource/mobiledevicecommands/command/UpdateInventory/id/101" -X POST