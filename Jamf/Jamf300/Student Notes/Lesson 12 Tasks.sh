#!/bin/bash
#Task 1a
#read -p "What is the Jamf Policy ID:     " policyID
##Task 1b
#sudo jamf policy -id "$policyID"
##Task 1c
#sudo jamf policy -id "$policyID" >> /Users/Shared/policy_results.txt
#

#Task 2
bootTime=$(sysctl kern.boottime | awk '{print $5}' | tr -d ,)
bootTimeFormatted=$(date -jf %s $bootTime +%F\ %T) # if you remove the \ after +%F you get just the date, not date and time the %T refers to Time so remove \ and %T to get just tthe date
echo "<result>$bootTimeFormatted</result>"

