#!/bin/bash
##################################################################
#: Date Created  : (January 15, 2018)
#: Author        : Daniel Griggs
#: Email         : dan@cmdsec.com
#: Version       : 0.10
##################################################################


######################
### VARIABLE BLOCK ###
######################
DOWNLOAD_URL="https://e3.boxcdn.net/box-installers/boxnotes/mac/latest/Box%20Notes.zip"

TMP_LOCATION="/tmp/box-notes"
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
  /bin/rm -f $TMP_LOCATION
}
trap cleanup_finish EXIT

send_user_message(){
  messageText="$1"

  managementAppPath="/Library/Application Support/JAMF/bin/Management Action.app/Contents/MacOS/Management Action"
  "$managementAppPath" -message "$messageText"
}

download_app(){
  mkdir $TMP_LOCATION
  /usr/bin/curl -s -o $TMP_LOCATION/box-notes.zip ${DOWNLOAD_URL}
}

install_app(){
  if [[ -e $TMP_LOCATION/box-notes.zip ]]; then
    unzip $TMP_LOCATION/box-notes.zip -d /Applications/
    #statements
  else
    echo "Failed to download box notes"
    send_user_message "FAILED: Could not download box notes app"
    exit 1
  fi
}

check_install(){
  if [[ -e "/Applications/Box Notes.app" ]]; then
    echo "Success, box notes installed"
    send_user_message "Finished installing box notes"
  else
    echo "Failed to install box notes after download"
    send_user_message "Could not install Box Notes, Contact IT"
    exit 1
  fi
}

######################
# END FUNCTIONS BLOCK #
######################
download_app

install_app

check_install

# https://e3.boxcdn.net/box-installers/boxedit/mac/currentrelease/BoxToolsInstaller.dmg

