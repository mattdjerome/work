#!/bin/bash

loggedInUser=$( echo "show State:/Users/ConsoleUser" | /usr/sbin/scutil | /usr/bin/awk '/Name :/ && ! /loginwindow/ { print $3 }' )
loggedInUID=$(/usr/bin/id -u "$loggedInUser" 2>/dev/null)

# Ensure swda is installed
if [[ ! -e /usr/local/bin/swda ]]; then
    echo "Could not locate the tool to set default mail client; running swda install policy."
    
fi

# Exit if nobody is logged in
[[ -z "$loggedInUser" ]] && echo "Nobody logged in; exiting." && exit 0

# Attempt to set default mail client
echo "Setting $loggedInUser's default mail client to Outlook..."
if ! /bin/launchctl asuser "$loggedInUID" /usr/local/bin/swda setHandler --mail --app "/Applications/Microsoft Outlook.app/"; then
    echo "Failed to set the default mail client for $loggedInUser."
    exit 2
fi

exit 0