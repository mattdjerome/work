#!/bin/bash

read -p "Please enter a Jamf Policy ID:  " policyID
#echo "$policyID"
mycommand=$(sudo jamf policy -id "$policyID")
echo "$mycommand"
sudo jamf policy -id "$policyID" > ~/Desktop/taskfile.txt
cat < /Users/localadmin/Desktop/taskfile.txt