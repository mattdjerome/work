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
DOWNLOAD_URL="https://box-installers.s3.amazonaws.com/boxedit/mac/currentrelease/BoxToolsInstaller.pkg"
DOWNLOAD_LOCATION=/tmp/box-tools.pkg

GUI_USER=$(who | grep console | grep -v '_mbsetupuser' | awk '{print $1}')
######################
# END VARIABLE BLOCK #
######################
#
#
#
######################
### FUNCTIONS BLOCK ##
######################
cleanup_finish(){
  echo "Starting cleanup_finish"
  # /usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${DMG_VOLUME_NAME}" | awk '{print $1}') -quiet
  /bin/rm -rf "$DOWNLOAD_LOCATION"
}
trap cleanup_finish EXIT

# send_user_message(){
#   messageText="$1"

#   managementAppPath="/Library/Application Support/JAMF/bin/Management Action.app/Contents/MacOS/Management Action"
#   "$managementAppPath" -message "$messageText"
# }


download_app(){
  echo "Starting box tools download"
  /usr/bin/curl -f -s -o "$DOWNLOAD_LOCATION" "$DOWNLOAD_URL"
  curlExitCode="$?"
  if [[ -e "$DOWNLOAD_LOCATION" ]] && [[ $curlExitCode == 0 ]]; then
    #statements
    echo "successfully downloaded box tools dmg"
  else
    echo "Failed to download box tools dmg, exiting"
    exit 1
  fi
}

install_app(){
  /usr/sbin/installer -pkg "$DOWNLOAD_LOCATION" -target / -lang en
}


######################
# END FUNCTIONS BLOCK #
######################
download_app

install_app

