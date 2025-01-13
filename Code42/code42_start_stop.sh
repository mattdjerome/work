#!/bin/bash

#This script will unload and then load the Code42 Service
#unload service
sudo echo "Stopping service."
if [ -e /Library/LaunchDaemons/com.code42.service.plist ];
then
    launchctl unload /Library/LaunchDaemons/com.code42.service.plist
    echo "Code42 Service Stopped."
else
    launchctl unload /Library/LaunchDaemons/com.crashplan.engine.plist
    echo "Crashplan Service Stopped."
fi
#Wait for 10 
echo "Waiting 10 seconds."
sleep 10
echo "10 second wait time completed. Restarting service."
#Load service
if [ -e /Library/LaunchDaemons/com.code42.service.plist ];
then
    launchctl load /Library/LaunchDaemons/com.code42.service.plist
    echo "Code42 Service Started."
else
    launchctl load /Library/LaunchDaemons/com.crashplan.engine.plist
    echo "Crashplan Service started."
fi
echo $?
echo "Process Complete."