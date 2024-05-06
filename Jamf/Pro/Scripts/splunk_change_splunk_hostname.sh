#!/bin/bash

# Which company the computer should be marked as
COMPANY_NAME="$4"
CURRENT_HOST_NAME=$(scutil --get LocalHostName)


SPLUNK_LOCATION="/opt/splunkforwarder/etc/system/local/inputs.conf"

# what to write to the conf file
NEW_HOST_NAME="$COMPANY_NAME-$CURRENT_HOST_NAME"

sed -i .bak "s|host.*|host = $NEW_HOST_NAME|g" "$SPLUNK_LOCATION"

chown splunk "$SPLUNK_LOCATION"

/bin/launchctl unload -w "/Library/LaunchDaemons/com.splunk.plist"
sleep 2
/bin/launchctl load -w "/Library/LaunchDaemons/com.splunk.plist"







#end

