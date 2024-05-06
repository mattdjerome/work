#!/bin/sh

#Jamf Pro Extension Attribute used to return a list of extensions in Google Chrome
current_user=$(ls -l /dev/console | awk '{print $3}')
echo $current_user
result=$(find /Users/$current_user/Library/Application\ Support/Google/Chrome/Default/Extensions -type f -name "manifest.json" -print0 | xargs -I {} -0 grep '"name":' "{}" | uniq | awk '{print $2 $3 $4 $5 $6}' | tr -d '",_:')

echo "<result>$result</result>"