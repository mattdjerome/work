#!/bin/bash

plistPath="/Library/LaunchDaemons/com.jamf.demo6.plist"
###UNLOAD###
if [[ -f $plistPath ]]; then
	sudo launchctl bootout system "$plistPath" # A DAEMON REQUIRES SUDO NO MATTER WHAT
	rm -f "$plistPath"
else
	echo "No File Found."
fi

#Step 1 make an agent in a location
defaults write "$plistPath" Label com.jamf.demo16
#Step 1=2: Have it do something
#In this case, open course resources, requires an array use ProgramArguments and -array
defaults write "$plistPath" ProgramArguments -array "/usr/local/bin/bash" "/Users/Shared/Resources/Files/mymanage.sh"

#Step 3 Set an Interval
defaults write "$plistPath" StartInterval -integer "14400"
#Step 4 Extra Stuff, adding RunAtLoad to start it when the system starts. RunatLoad vs Startup. It must be loaded to memory before it can run, that why RunAtLoad is used aka 
defaults write "$plistPath" RunAtLoad -boolean true

#Change Permissions and Ownership
chmod 644 "$plistPath"
chown root:wheel "$plistPath"

#Load the Process
launchctl bootstrap system "$plistPath"