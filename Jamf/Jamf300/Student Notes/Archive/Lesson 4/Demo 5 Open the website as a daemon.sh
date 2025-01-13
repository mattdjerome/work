#!/bin/bash

plistPath="/Library/LaunchAgents/com.jamf.demo3.plist"

###Unload###
if [[ -f $plistPath ]];then
	sudo launchctl bootout system "$plistPath"
	rm -f "$plistPath"
else
	echo "No file found."
fi

############Make an Daemon######### 
#Step 1: Make a label.
defaults write "$plistPath" Label com.jamf.demo3

#Step 2: Have it do something

defaults write "$plistPath" ProgramArguments -array "/usr/bin/open" "https://jamf.it/courseresources"

#Step 3 Extra stuff 
defaults write "$plistPath" RunAtLoad -boolean true


####CHange Permissions and ownership

chmod 644 "$plistPath"
chown root:wheel "$plistPath"

####Load the process
sudo launchctl bootstrap system "$plistPath"