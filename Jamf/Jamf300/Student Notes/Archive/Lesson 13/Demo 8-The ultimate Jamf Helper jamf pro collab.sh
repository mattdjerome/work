#!/bin/bash

jTitle="$4"
jDescription="$5"
jIcon="$6"
jButton1="$7"
JButton2="$8"
jamfHelped=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "$jTitle" -description "$jDescription" -icon "$jIcon" -button1 "$jButton1" -button2 "$JButton2" -defaultButton "1")

if [[ "$jamfHelped" == "0" ]];then
	jamf policy id 5
	echo "You chose to be secure. Good job! "
else
	echo "You like to live dangerous."
	jamf displayMessage -message "You have chose poorly....shame..shame.shame.."
fi