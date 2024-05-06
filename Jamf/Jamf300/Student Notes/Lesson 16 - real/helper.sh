#!/bin/bash

messageToDisplay="$4"
policyID="$5"
policyAction1="$6" 
policyAction2="$7"
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" 

buttonClicked=$( "$jamfHelper" -windowType utility -description "$messageToDisplay" -button1 "View" -button2 "Execute" ) 

if [[ "$buttonClicked" = "0" ]];then
#su "$3" -c says switch to the user in $3
	su "$3" -c "open 'jamfselfservice://content?entity=policy&id=$policyID&action=$policyAction1'"
else
	su "$3" -c "open 'jamfselfservice://content?entity=policy&id=$policyID&action=$policyAction2'"
fi