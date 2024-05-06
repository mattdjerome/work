#!/bin/bash
##################################################################
#: Date Created  : (June 12, 2018)
#: Author        : Daniel Griggs
#: Email         : dan@cmdsec.com
#: Version       : 0.10
##################################################################


######################
### VARIABLE BLOCK ###
######################
GUI_USER=$(who | grep console | grep -v '_mbsetupuser' | awk '{print $1}')

LATEST_VERSION="$4"
######################
# END VARIABLE BLOCK #
######################
#
#
#
#######################
### FUNCTIONS BLOCK ###
#######################


######################
# END FUNCTIONS BLOCK #
######################

installedBoxVersion=$(defaults read /Applications/Box.app/Contents/Info.plist CFBundleVersion)

if [[ "$LATEST_VERSION" == "$installedBoxVersion" ]]; then
  #statements
  echo "#######"
  echo "Target Box Drive version already installed, exiting"
  echo "#######"
  exit 1
fi

echo "#######"
echo "GUI_USER:$GUI_USER"
echo "#######"
# Find the box drive folder
boxDriveFolder=$(find "/Users/$GUI_USER" -maxdepth 2 -name Box)
echo "#######"
echo "Box Drive folder:$boxDriveFolder"
echo "#######"

if [[ -z "$boxDriveFolder" ]]; then
  echo "#######"
  echo "Box Drive not installed, exiting"
  echo "#######"
  exit 1
fi

# Find any open files
openFiles=$(lsof "$boxDriveFolder/")
echo "$openFiles"

# If nothing open, update
if [[ -z $openFiles ]]; then
  #statements
  echo "####"
  echo "#### Time to update!"
  echo "####"
  # clean quit box, update will not install if you don't
  /usr/bin/killall -QUIT Box
  /usr/local/bin/jamf policy -event installBoxDrive
  sleep 3
  # Installer doesn't open box again, jus tlaunch the box app
  sudo -u $GUI_USER open -a /Applications/Box.app 2>/dev/null
  exit 0
else
  # If something open, quit
  echo "####"
  echo "#### Found open files, bailing out"
  echo "####"
  exit 1
fi








# end

