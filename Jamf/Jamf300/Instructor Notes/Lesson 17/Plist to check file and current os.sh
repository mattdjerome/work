#!/bin/bash

#defaults read /Users/Shared/com.myOS.mac.plist

currentOS=$(sw_vers -productVersion)

plistOS=$(defaults read /Users/Shared/com.myOS.mac.plist myOS)
if [[ "$currentOS" != "$plistOS" ]];then 
	jamf recon
	jamf policy -event osupdate
	
else
	echo "They are the same."
fi