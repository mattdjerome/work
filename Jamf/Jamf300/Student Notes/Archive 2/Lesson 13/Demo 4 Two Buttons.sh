#!/bin/bash

/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Important Message" -description "You have a message from IT. Have a nice day!" -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns" -button1 "Ok" -button2 "Not Now." -defaultButton "1"