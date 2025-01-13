#!/bin/bash

#curl -m 10 -ks https://t300-1a.pro.jamf.training/healthCheck.html

jURL="https://t300-1a.pro.jamf.training"
healthStatus=$(curl -m 10 -ks "$jURL"/healthCheck.html)
if [[ "$healthStatus" == "[]" ]];then
	echo "$healthStatus"
	echo "Your Jamf Pro is healthy. "
else
	echo "$healthStatus"
	open -a Safari "https://learn.jamf.com/bundle/jamf-pro-documentation-current/page/Jamf_Pro_Health_Check_Page.html"
fi
