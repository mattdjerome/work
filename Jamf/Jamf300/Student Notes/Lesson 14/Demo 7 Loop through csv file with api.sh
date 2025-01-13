#!/bin/bash

jUNPW="jamfadmin:2023Holmes!"
basicAuth=$(echo -n $jUNPW | base64)
jURL="https://t300-1a.pro.jamf.training"

#Get Bearer Token with Basic Auth
bToken=$(curl -sk -X POST "$jURL/api/v1/auth/token" -H "accept: application/json" -H "Authorization: Basic $basicAuth" | awk '/token/{print $3}' | tr -d '"'',')


IFS=,
while read bldg id room;do

	curl -sk -H "Authorization: Bearer $bToken" -H "content-type: text/xml" "$jURL/JSSResource/computers/id/$id" -X PUT -d "<computer><general><location><building>$bldg</building><room>$room</room></location></general></computer>"
	sleep 1
	
done < /Users/localadmin/Desktop/example.csv