#!/bin/bash

#osascript -e 'display dialog "Please type in your asset tag" default answer "JS#####" buttons {"OK"} default button 1'

#osascript -e 'text returned of(display dialog "Please type in your asset tag" default answer "JS#####" buttons {"OK"} default button 1)'
#osascript << EOF
#text returned of (display dialog "Please type in your asset tag" default answer "JS#####" buttons {"OK"} default button 1)
#EOF

myTag=$(osascript << EOF
text returned of (display dialog "Please type in your asset tag" default answer "JS#####" buttons {"OK"} default button 1)
EOF
)
sudo jamf recon -assetTag "$myTag"