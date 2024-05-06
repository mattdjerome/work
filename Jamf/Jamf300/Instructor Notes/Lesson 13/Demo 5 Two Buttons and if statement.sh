#!/bin/bash

jamfHelped=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Important Message" -description "Would you like to update your inventory?" -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns" -button1 "Ok" -button2 "Not Now." -defaultButton "1")
if [[ "$jamfHelped" == "0" ]];then
	jamf recon
else
	echo "Not now."
	jamf displayMessage -message "Maybe later.."
fi

