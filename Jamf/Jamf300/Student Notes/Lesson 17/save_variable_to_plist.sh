#!/bin/bash

currentOS=$(sw_vers -productVersion)

plistOS=$(defaults read /Users/Shared/com.myOS.mac.plist myOS)
plistPath=""

cat > "$scriptPath" << "LOL"
if [[ "$currentOS" != "$plistOS" ]]; then
    jamf recon
    jamf policy -trigger osUpdate 
    

