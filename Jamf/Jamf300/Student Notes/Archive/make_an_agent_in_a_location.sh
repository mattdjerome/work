#!/bin/bash

plistPath="/Library/LaunchAgents/com.jamf.demo3.plist"
###UNLOAD###
if [[ -f $plistPath ]]; then
	launchctl bootout gui/502 "$plistPath"
	rm -f "$plistPath"
else
	echo "No File Found."
fi

#Step 1 make an agent in a location
defaults write "$plistPath" Label com.jamf.demo1

#Step 1=2: Have it do something
#In this case, open course resources, requires an array use ProgramArguments and -array
defaults write "$plistPath" ProgramArguments -array "/usr/bin/open" "https://jamf.it/courseresources"

#Step 3 Extra Stuff, adding RunAtLoad to start it when the system starts. RunatLoad vs Startup. It must be loaded to memory before it can run, that why RunAtLoad is used aka bootstrapping. Starting means it performs the action. RunAtLoad is an immediate action
defaults write "$plistPath" RunAtLoad -boolean true

#Change Permissions and Ownership
chmod 644 "$plistPath"
chown root:wheel "$plistPath"

#Load the Process
launchctl bootstrap gui/502 "$plistPath"