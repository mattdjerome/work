#!/bin/bash

#read -p "You have stepped in front of a door. Do you turn left or right:     " UserChoice
#echo "$UserChoice"
#read -p "Please enter Username:   " myUsername
#read -p "Please enter Password:   " myPassword
#echo "My username is $myUsername and my Password is $myPassword"

#read -sp "Please enter Username:   " myUsername
#read -sp "Please enter Password:   " myPassword
#echo "My username is $myUsername and my Password is $myPassword"

read -p "Please enter a Jamf Policy ID:  " policyID
sudo jamf policy -id "$policyID"