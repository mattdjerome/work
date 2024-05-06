#!/bin/bash


launchctl list | grep com.jamf.demo5


if [[ $? = 0 ]];then
launchctl bootout system /Library/LaunchDaemons/com.jamf.demo5.plist
fi