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

DMG_FILE="FF.dmg"

# choose language (en-US, fr, de)
LANG="en-US"
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
}
trap cleanup_finish EXIT

send_user_message(){
  messageText="$1"

  managementAppPath="/Library/Application Support/JAMF/bin/Management Action.app/Contents/MacOS/Management Action"

  "$managementAppPath" -message "$messageText"
}

get_versions(){
  echo "Starting get_versions"

  ## Get OS version and adjust for use with the URL string
  osVerForURL=$( sw_vers -productVersion | sed 's/[.]/_/g' )

  ## Set the User Agent string for use with curl
  userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${osVerForURL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

  # Get the latest version of Reader available from Firefox page.
  latestVersion=$(/usr/bin/curl -s -A "$userAgent" https://www.mozilla.org/${LANG}/firefox/new/ | grep 'data-latest-firefox' | sed -e 's/.* data-latest-firefox="\(.*\)".*/\1/' -e 's/\"//' | /usr/bin/awk '{print $1}')
  echo "Latest Version is: $latestVersion"

  # Get the version number of the currently-installed FF, if any.
  if [ -e "/Applications/Firefox.app" ]; then
  	currentInstalledVersion=$(/usr/bin/defaults read /Applications/Firefox.app/Contents/Info CFBundleShortVersionString)
  	echo "Current installed version is: $currentInstalledVersion"
  	if [ ${latestVersion} = ${currentInstalledVersion} ]; then
  		echo "Firefox is current. Exiting"
  		exit 0
  	fi
  else
  	currentInstalledVersion="none"
  	echo "Firefox is not installed"
  fi

  url="https://download-installer.cdn.mozilla.net/pub/firefox/releases/${latestVersion}/mac/${LANG}/Firefox%20${latestVersion}.dmg"

  echo "Latest version of the URL is: $url"
}

install_firefox(){
  /bin/echo "starting install_firefox"
  /bin/echo "Current Firefox version: ${currentinstalledver}"
  /bin/echo "Available Firefox version: ${latestver}"
  /bin/echo "Downloading newer version."
  /usr/bin/curl -s -o /tmp/${DMG_FILE} ${url}
  /bin/echo "Mounting installer disk image."
  /usr/bin/hdiutil attach /tmp/${DMG_FILE} -nobrowse -quiet
  /bin/echo "Installing..."
  
  ditto -rsrc "/Volumes/Firefox/Firefox.app" "/Applications/Firefox.app"
  /bin/sleep 10
  /bin/echo "Unmounting installer disk image."
  /usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep Firefox | awk '{print $1}') -quiet
  /bin/sleep 10

  send_user_message "Finished Installing Firefox"

  /bin/echo "Deleting disk image."
}


######################
# END FUNCTIONS BLOCK #
######################


# Initial install
get_versions

if [ "${currentInstalledVersion}" != "${latestVersion}" ]; then
  install_firefox
fi

# Check to make sure install worked correctly
get_versions
if [ "${currentInstalledVersion}" != "${latestVersion}" ]; then
  echo "install failed"
  exit 1
else
  echo "install successful"
  exit 0
fi


# End

