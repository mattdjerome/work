#!/bin/bash
##################################################################
#: Date Created  : Mar 14, 2017
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
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
iconPath="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/"
scriptName=$( echo ${0##*\/} | cut -d. -f1 )


## Splunk VARS ###
splunkTarDownloadURL='https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86&platform=macos&version=6.6.2&product=universalforwarder&filename=splunkforwarder-6.6.2-4b804538c686-darwin-64.tgz&wget=true'

splunkScriptHome=/opt/splunkforwarder

splunkExe="$splunkScriptHome/bin/splunk"

splunkDownloadMD5="6ad5bcc898a2c3875444f6c921bde693"
######################
# END VARIABLE BLOCK #
######################
#
#
#
######################
### FUNCTION BLOCK ###
######################
logIt(){
  logger -t secureConfig "$1  ### $scriptName"
  echo  "$1  ### $scriptName"
}

jamfHelper(){
  title="$1"
  message="$2"
  icon="$3"
  "$jamfHelper" -windowType utility -title "$title" -description "$message" -button1 "Ok" -icon "$iconPath/$icon" -iconSize "100"
}

# checkFileExists(){
#   fileToCheck="$1"
#   if [[ -e "$fileToCheck" ]]; then
#     # return true
#     return 0
#   else
#     # return false
#     return 1
#   fi
# }
######################
# END FUNCTION BLOCK #
######################

########################
# SCRIPT SPECIFIC VARS #
########################
# $SPLUNK_HOME/etc/system/local/deploymentclient.conf base64 hash
# deploymentClientConfBase64="W3RhcmdldC1icm9rZXI6ZGVwbG95bWVudFNlcnZlcl0KdGFyZ2V0VXJpID0gaW5wdXQtcHJkLXAtemszYmNicHFqN3NrLmNsb3VkLnNwbHVuay5jb206ODA4OQo="

splunkCloudUFcertFileBase64="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"


# exmaple to check the FUNCTION
# checkFileExists "/opt/" && echo "yes"

#################
## Download splunk to the /tmp/ folder
#################

clearPreviousTries(){
  logIt "Clearing previous installs"
  # Kill all the splunk processes
  killall splunk
  killall splunkd

  # Clear any previous attempts
  rm /tmp/splunk-forwarder.tgz

  # Clear out the opt folder from any previous installs
  if [[ -d /opt/splunkforwarder ]]; then
    rm -rf /opt/splunkforwarder
  fi

}

checkComputerHostName(){
  # Make sure the hostname is set on the machine, redirect b/c scutil is a pain
  currentHostName=$(scutil --get HostName 2>&1 )
  # echo $currentHostName
  if [[ $currentHostName =~ not ]]; then
    logIt "Changing the hostname to match the LocalHostName"
    localHostName=$(scutil --get LocalHostName)
    scutil --set HostName "$localHostName.local"
  fi
}

createSplunkUser(){
  logIt "Creating the splunk user"
  dscl . delete /Users/splunk
  dscl . -create /Users/splunk
  dscl . -create /Users/splunk UserShell /usr/bin/false
  dscl . -create /Users/splunk UniqueID 550
  # Don't make it admin user
  dscl . -create /Users/splunk PrimaryGroupID 20
  dscl . -create /Users/splunk NFSHomeDirectory /var/splunk
  dscl . -passwd /Users/splunk Et2koAgom17SdifbSler4JkY7HXXps2y
  dscl . -create /Users/splunk IsHidden 1

  # Make the home folder for the little .splunk credentials file the server needs
  if [[ ! -d /var/splunk ]]; then
    mkdir /var/splunk
    chown splunk /var/splunk
  fi

}

installSplunkComponents(){
  logIt "Downloading and installing the splunk components"
  # Curl to actually download
  curl -L -o /tmp/splunk-forwarder.tgz "$splunkTarDownloadURL"
  # Check to make sure the curl command worked
  if [[ $? != 0 ]]; then
    logIt "Failed to download splunk (curl), exiting"
    exit 1
  fi

  if [[ $(md5 -q /tmp/splunk-forwarder.tgz) != "$splunkDownloadMD5" ]]; then
    logIt "Failed to download splunk (md5 check), exiting"
    exit 1
  fi

  if [[ ! -d /opt/ ]]; then
    mkdir /opt/
  fi

  # Untar splunk to the correct location
  tar -xvzf /tmp/splunk-forwarder.tgz -C /opt/

  # Make sure root and wheel are the owners of the opt files
  chown -R splunk /opt/splunkforwarder/


  ### Check to make sure splunk is installed at all
  if [[ -e $splunkScriptHome ]]; then
    logIt "Splunk - installed, continuing config script"
  else
    logIt "Splunk - Not installed at $splunkScriptHome, exiting"
    exit 1
  fi
}


finalSplunkConfigAndFirstStart(){
  logIt "Final config and splunk start"
  ## Make sure splunk is running
  sudo -H -u splunk "$splunkExe" start --accept-license --answer-yes --auto-ports --no-prompt

  sudo -H -u splunk "$splunkExe" login -auth admin:changeme


  ## Write down the splunk cloud cert file
  echo "$splunkCloudUFcertFileBase64" | base64 -D -o /tmp/splunkCloudCert.spl

  # install the cert file to the splunk instance.
  sudo -H -u splunk "$splunkExe" install app /tmp/splunkCloudCert.spl -auth admin:changeme

  ## Setup the client to be managed by the splunk server
  sudo -H -u splunk "$splunkExe" set deploy-poll input-prd-p-dt6q4wlxxpss.cloud.splunk.com:8089

  ## Change the admin password away from the default.
  sudo -H -u splunk "$splunkExe" edit user admin -password "Et2koAgom17SdifbSler4JkY7HXXps2y" -role admin -auth admin:changeme

  ## Reboot the client so all the changes will take effect
  sudo -H -u splunk "$splunkExe" stop

   # Reboot to clean everything up
  logIt "Time to restart splunk"
  "$splunkExe" enable boot-start -user splunk
  ## Reboot the client so all the changes will take effect
  sudo -H -u splunk "$splunkExe" restart

  ## Move the launchAgent to the correct position in launchDaemons
  logIt "Moving the launchAgent so it becomes a launchDaemon"
  mv /Library/LaunchAgents/com.splunk.plist /Library/LaunchDaemons/
}

persist_splunk() {
  #######################################
  # Use:
  #   Will start splunk again if it has crashed
  # Arguments:
  #  none
  # Notes:
  #  this is intentionally brute force for consistency
  #######################################
  SPLUNK_LAUNCHD_PLIST_BASE64="PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHBsaXN0IFBVQkxJQyAiLS8vQXBwbGUvL0RURCBQTElTVCAxLjAvL0VOIiAiaHR0cDovL3d3dy5hcHBsZS5jb20vRFREcy9Qcm9wZXJ0eUxpc3QtMS4wLmR0ZCI+CjxwbGlzdCB2ZXJzaW9uPSIxLjAiPgo8ZGljdD4KCTxrZXk+S2VlcEFsaXZlPC9rZXk+Cgk8dHJ1ZS8+Cgk8a2V5PkxhYmVsPC9rZXk+Cgk8c3RyaW5nPmNvbS5zcGx1bmsuc3RyZWFtPC9zdHJpbmc+Cgk8a2V5PlByb2dyYW1Bcmd1bWVudHM8L2tleT4KCTxhcnJheT4KCQk8c3RyaW5nPi9vcHQvc3BsdW5rZm9yd2FyZGVyL2Jpbi9zcGx1bms8L3N0cmluZz4KCQk8c3RyaW5nPnN0YXJ0PC9zdHJpbmc+CgkJPHN0cmluZz4tLW5vLXByb21wdDwvc3RyaW5nPgoJCTxzdHJpbmc+LS1hbnN3ZXIteWVzPC9zdHJpbmc+Cgk8L2FycmF5PgoJPGtleT5SdW5BdExvYWQ8L2tleT4KCTx0cnVlLz4KPC9kaWN0Pgo8L3BsaXN0Pgo="

  SPLUNK_LAUNCH_DAEMON_FILE="/Library/LaunchDaemons/com.splunk.plist"
  SPLUNK_LAUNCH_DAEMON_NAME="com.splunk"


  echo "$SPLUNK_LAUNCHD_PLIST_BASE64" | base64 -D -o "$SPLUNK_LAUNCH_DAEMON_FILE" || logIt "FAILED: Create splunk launchDaemon file"
  chown root:wheel "$SPLUNK_LAUNCH_DAEMON_FILE"

  logIt "FIX: loading splunk launchDaemon"
  /bin/launchctl load -w "$SPLUNK_LAUNCH_DAEMON_FILE" || logIt "FAILED: Load splunk launch daemon"




}

blockSplunkOnFirewall(){
#######################################
# Use:

# Arguments:
#  none
# Returns:
#  none
#######################################

echo "Starting blockSplunkOnFirewall"

# add Splunk daemon to the app list
/usr/libexec/ApplicationFirewall/socketfilterfw --add /opt/splunkforwarder/bin/splunkd
# Add the block rule in the Firewall
/usr/libexec/ApplicationFirewall/socketfilterfw --blockapp /opt/splunkforwarder/bin/splunkd

# Reg splunk it to the app list
/usr/libexec/ApplicationFirewall/socketfilterfw --add /opt/splunkforwarder/bin/splunk
# Add the block rule in the Firewall
/usr/libexec/ApplicationFirewall/socketfilterfw --blockapp /opt/splunkforwarder/bin/splunk

}

cleanUpTmpFolder(){
  rm /tmp/splunkCloudCert.spl
  rm /tmp/splunk-forwarder.tgz
  rm -rf /tmp/splunk*
}



##### Start of the actions ########
clearPreviousTries

checkComputerHostName

createSplunkUser

installSplunkComponents

# Not needed, replaced by the deploy poll command in finalSplunkConfigAndFirstStart
# configureDeploymentClient

blockSplunkOnFirewall

finalSplunkConfigAndFirstStart

# persist_splunk

cleanUpTmpFolder

# Add splunk to firewall so there are no prompts
/usr/libexec/ApplicationFirewall/socketfilterfw --add /opt/splunkforwarder/bin/splunkd

/usr/libexec/ApplicationFirewall/socketfilterfw --blockapp /opt/splunkforwarder/bin/splunkd














# some comment

