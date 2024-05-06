#!/bin/bash

#/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper


#/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -help

#/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud
#/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility
macSerial=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}')

/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -title "Mac Serial: $macSerial" -description "You have a message from IT. Have a nice day!"