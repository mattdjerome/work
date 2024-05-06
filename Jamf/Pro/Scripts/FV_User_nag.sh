#!/bin/bash
##################################################################
#: Date Created  : Oct 28, 2016
#: Author        : Daniel Griggs
#: Email         : dan@cmdsec.com
#: Version       : 1.00
##################################################################


######################
### VARIABLE BLOCK ###
######################
# OSver=$(sw_vers -productVersion | cut -d. -f1,2) # (if 10.10.3) returns 2nd digit of 10
# users=$(dscl . list /users shell | egrep -v '(^_)|(root)|(/usr/bin/false)' | awk '{print $1}')
# mgmtUser="cmdadmin"
# jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# iconPath="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/"
# scriptName=$( echo ${0##*\/} | cut -d. -f1 )
######################
# END VARIABLE BLOCK #
######################
#
#

checkFilevaultAlreadyEnabled(){
  local fvStatus=$(fdesetup status)
  if [[ $fvStatus == "FileVault is On." ]]; then
    echo "FileVault Already enabled"
    exit 0
  fi
}

jamf_helper_icon(){
  ## Prompt the user, let them know what is happening
  userPromptAnswer=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -heading "A message from Emerson IT" -description "FileVault is not enabled and your computer is at risk.

Please reboot your computer as soon as possible to finish enabling FileVault." -icon /var/cmdSec/logo.png -button1 "Reboot now" -button2 "Later" -defaultButton 1)
}

jamf_helper_no_icon(){
	echo "##### Starting jamf_helper_no_icon"

  userPromptAnswer=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon "/Applications/Utilities/Keychain Access.app/Contents/Resources/Keychain_Locked.png" -heading "A message from Emerson IT" -description "FileVault is not enabled and your computer is at risk.

Please reboot your computer as soon as possible to finish enabling FileVault." -button1 "Reboot now" -button2 "Later" -defaultButton 1)


	echo "##### Finished jamf_helper_no_icon"
	echo " "
}


# currentUser=$(who | grep console | awk '{print $1}' | grep -v '^_')
# loggedInPID=$( ps -axj | awk "/^root/ && /jamfAgent/ {print \$2;exit}" )

# echo "|$currentUser|"
# echo "PID is $loggedInPID"


checkFilevaultAlreadyEnabled

if [[ -e /var/cmdSec/logo.png ]]; then
  jamf_helper_icon
  #statements
else
  jamf_helper_no_icon
fi

echo "$userPromptAnswer"
if [[ "$userPromptAnswer" == 0 ]]; then
  echo "reboot"
  /usr/bin/osascript << EOF
ignoring application responses
tell application "Finder" to restart
end ignoring
EOF
  # echo "bsexec $loggedInPID as $currentUser"
  # sudo -iu "$currentUser"
else
  echo "not now"
fi


#
#   /usr/bin/osascript << EOF
# ignoring application responses
# tell application "loginwindow" to «event aevtlogo»
# end ignoring





# End

