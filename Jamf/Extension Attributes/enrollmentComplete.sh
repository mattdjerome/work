#!/bin/bash

symPath="/Library/Fanatics/.initialSetupComplete"
smPath="/private/var/db/.JamfSetupEnrollmentDone"

if [[ -e "$symPath" ]] || [[ -e "$smPath" ]]; then
	result="<result>Complete</result>"
else 
	result="<result>Unknown</result>"
fi
echo $result