#!/bin/bash

plistPath="/Library/LaunchDaemons/com.jamf.demo15.plist"

###Unload###
if [[ -f $plistPath ]];then
	sudo launchctl bootout system "$plistPath"
	rm -f "$plistPath"
else
	echo "No file found."
fi

############Make an Daemon######### 
#Step 1: Make a label.
defaults write "$plistPath" Label com.jamf.demo5

#Step 2: Have it do something

defaults write "$plistPath" ProgramArguments -array "/bin/bash" "/Users/Shared/mymanage.sh"

#Step 3:
defaults write "$plistPath" StartInterval -integer "14400"

#Step 4 Extra stuff 
defaults write "$plistPath" RunAtLoad -boolean true


####CHange Permissions and ownership

chmod 644 "$plistPath"
chown root:wheel "$plistPath"

####Load the process
sudo launchctl bootstrap system "$plistPath"