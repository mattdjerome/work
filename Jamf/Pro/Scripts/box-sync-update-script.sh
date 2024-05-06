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

installedBoxVersion=$(defaults read "/Applications/Box Sync.app/Contents/Info.plist" CFBundleVersion)

if [[ "$LATEST_VERSION" == "$installedBoxVersion" ]]; then
  #statements
  echo "#### Target Box Sync version already installed, exiting"
  echo "#######"
  exit 1
fi

echo "#### GUI_USER:$GUI_USER"
echo "#######"
# Find the Box Sync folder
boxDriveFolder=$(find "/Users/$GUI_USER" -maxdepth 2 -name "Box Sync")
echo "#### Box Sync folder:$boxDriveFolder"
echo "#######"

if [[ -z "$boxDriveFolder" ]]; then
  echo "#### Box Sync not installed, exiting"
  echo "#######"
  exit 1
fi


echo "####"
echo "#### Time to update!"
echo "####"
# clean quit box, update will not install if you don't
/usr/bin/killall -QUIT "Box Sync"
/usr/local/bin/jamf policy -event installBoxSync
sleep 1
# Installer doesn't open box again, jus tlaunch the box app
sudo -u $GUI_USER open -a "/Applications/Box Sync.app" 2>/dev/null
exit 0






# end

