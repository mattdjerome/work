#!/bin/bash
##################################################################
#: Date Created  : (January 15, 2018)
#: Author        : Daniel Griggs
#: Email         : dan@cmdsec.com
#: Version       : 0.10
##################################################################


# adapted from Joe Farage's Firefox script
# https://www.jamf.com/jamf-nation/discussions/12956/firefox-update-script

######################
### VARIABLE BLOCK ###
######################
DMG_FILE_NAME="slack_script_download.dmg"
DMG_VOLUME_NAME="Slack.app"

URL="https://slack.com/ssb/download-osx"
# /usr/bin/curl -L -o /tmp/slack_script_download.dmg "https://slack.com/ssb/download-osx"
######################
# END VARIABLE BLOCK #
######################
#
#
#
######################
### FUNCTIONS BLOCK ###
######################
cleanup_finish(){
  echo "Starting cleanup_finish"

  /usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${DMG_VOLUME_NAME}" | awk '{print $1}') -quiet

  # /bin/rm /tmp/${DMG_FILE_NAME}
}
trap cleanup_finish EXIT

send_user_message(){
  messageText="$1"

  managementAppPath="/Library/Application Support/JAMF/bin/Management Action.app/Contents/MacOS/Management Action"

  "$managementAppPath" -message "$messageText"
}


download(){
  /bin/echo "--"
  /bin/echo "Downloading latest version."
  /usr/bin/curl -L -o /tmp/${DMG_FILE_NAME} ${URL}
}

mount_dmg(){
  /bin/echo "Mounting installer disk image."
  /usr/bin/hdiutil attach /tmp/${DMG_FILE_NAME} -nobrowse -quiet
  if [[ ! -e /Volumes/${DMG_VOLUME_NAME} ]]; then
    ls -la /Volumes/
    exit 1
    #statements
  fi
}

install_from_dmg(){
  /bin/echo "Installing..."
  ditto -rsrc "/Volumes/${DMG_VOLUME_NAME}/Slack.app" "/Applications/Slack.app"
  /bin/sleep 2
  /bin/echo "Unmounting installer disk image."
  /usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${DMG_VOLUME_NAME}" | awk '{print $1}') -quiet
  /bin/sleep 2
  /bin/echo "Deleting disk image."
  # /bin/rm /tmp/"${DMG_FILE_NAME}"
}
######################
# END FUNCTIONS BLOCK #
######################

download

mount_dmg

install_from_dmg

send_user_message "Finished installing Slack"

exit 0

