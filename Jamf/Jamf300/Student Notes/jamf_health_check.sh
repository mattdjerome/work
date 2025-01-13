#!/bin/bash

jURL="https://t300-11a.pro.jamf.training"

healthStatus=$(curl -m 10 -ks "$jURL"/healthCheck.html)

if [[ "$healthStatus" == "[]" ]]; then
    echo "Your Jamf Pro is Healthy. "
else
    echo "$healthStatus"
    open -a Safari "https://learn.jamf.com/bundle/jamf-pro-documentation-current/page/Jamf_Pro_Health_Check_Page.html"
fi