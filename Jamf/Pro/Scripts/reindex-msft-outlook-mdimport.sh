#!/bin/bash
##################################################################
#: Date Created  : (August 25, 2019)
#: Author        : Daniel Griggs
#: Email         : dan@cmdsec.com
#: Version       : 0.10
##################################################################


######################
### VARIABLE BLOCK ###
######################
OS_VER=$(sw_vers -productVersion | cut -d. -f1,2) # (if 10.10.3) returns 10.10
USERS=$(dscl . list /users shell | egrep -v '(^_)|(root)|(/usr/bin/false)' | awk '{print $1}')
MGMT_USER=""

SCRIPT_NAME=$( echo ${0##*\/} | cut -d. -f1 )
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

send_user_notification_center_message(){
  messageText="$1"

  managementAppPath="/Library/Application Support/JAMF/bin/Management Action.app/Contents/MacOS/Management Action"
  "$managementAppPath" -message "$messageText"
}

######################
# END FUNCTIONS BLOCK #
######################

countOfImporters=$(/usr/bin/mdimport -L | grep -ic outlook)

case $countOfImporters in
  1)
    echo "found one"
    /usr/bin/mdimport -r "/Applications/Microsoft Outlook.app/Contents/Library/Spotlight/Microsoft Outlook Spotlight Importer.mdimporter"
    send_user_notification_center_message "Success: Starting Outlook re-index, this may take up to two hours."
    ;;
  0)
    echo "found none"
    send_user_notification_center_message "Error: No MSFT Outlook Spotlight importer found, call IT"
    exit 1
    ;;
  *)
    echo "found unknown"
    send_user_notification_center_message "Error: Error with MSFT Outlook Spotlight importer call IT"
    exit 1
    ;;
esac





















#end
 
