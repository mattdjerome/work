#!/bin/bash

jTitle="Important Messag"
jDescription="Would you like to turn on FileVault?"
jIcon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
jButton1="Yes"
JButton2="Not Now."
jamfHelped=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "$jTitle" -description "$jDescription" -icon "$jIcon" -button1 "$jButton1" -button2 "$JButton2" -defaultButton "1")

if [[ "$jamfHelped" == "0" ]];then
	jamf policy id 5
	echo "You chose to be secure. Good job! "
else
	echo "You like to live dangerous."
	jamf displayMessage -message "You have choses poorly....shame..shame.shame.."
fi