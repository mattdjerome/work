#!/bin/bash

launchctl unload /Library/LaunchDaemons/com.code42.service.plist
chflags noschg /Applications/Code42.app 
chmod -R 755 "/Library/Application Support/CrashPlan/"

/Library/Application\ Support/CrashPlan/Uninstall.app/Contents/Resources/uninstall.sh
#rm /Library/Application\ Support/CrashPlan/.identity
#commented line 8 so that code42 leaves identity file so that the computer knows the computer and does not need to "adopt" a new computer
exit 0
