#!/bin/bash

plistPath="/Library/LaunchAgents/com.jamf.demo2.plist"
############Make an agent######### 
#Step 1: Make a label.
defaults write "$plistPath" Label com.jamf.demo1

#Step 2: Have it do something

defaults write "$plistPath" ProgramArguments -array "/usr/bin/open" "https://jamf.it/courseresources"

#Step 3 Extra stuff 
defaults write "$plistPath" RunAtLoad -boolean true


####CHange Permissions and ownership

chmod 644 "$plistPath"
chown root:wheel "$plistPath"

####Load the process
launchctl bootstrap gui/501 "$plistPath"