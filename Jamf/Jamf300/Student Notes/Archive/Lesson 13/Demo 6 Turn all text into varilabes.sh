#!/bin/bash

jTitle="Important Messag"
jDescription="You have a message from IT. Have a nice day!"
jIcon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
jButton1="Ok"
JButton2="Not Now."
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "$jTitle" -description "$jDescription" -icon "$jIcon" -button1 "$jButton1" -button2 "$JButton2" -defaultButton "1"