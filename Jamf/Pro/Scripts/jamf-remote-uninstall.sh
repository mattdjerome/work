#!/bin/bash
# This script runs one last recon, updates the JSS API to show the machine is unmanaged, and then creates a launchd to remove the jamf framework.

# Define variables

jssServer="https://wjec-2a.cmdsec.com"
name=$(scutil --get ComputerName)
# curlName=$(echo "$name"|sed 's/ /%20/g')
xmlString="<?xml version=\"1.0\" encoding=\"UTF-8\"?><computer><general><remote_management><managed>false</managed><management_username/></remote_management></general></computer>"
jamf_binary="/usr/local/bin/jamf"


# Update the computer inventory
RunRecon (){
    $jamf_binary recon
}

cmdadmin_user(){
    echo "##### Starting cmdadmin_user"
    /usr/bin/fdesetup remove -user cmdadmin
    /usr/bin/dscl . -delete "/Users/cmdadmin"

    rm -rf /Users/cmdadmin

    rm -rf /var/cmdadmin

}

# Use the API to update the management
# status of the computer
# Takes a parameter for the computer name
UpdateAPI (){
    curl -sS -k -i -u ${apiUsername}:${apiPassword} -X PUT -H "Content-Type: text/xml" -d "${xmlString}" ${jssServer}/JSSResource/computers/name/$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$name")
}

# Create a temp launchd job in /private/tmp/ that uses a RunAtLoad key of false and StartInterval of 60 seconds
# This is done so that the script can return a result to the JSS before the framework is removed
CreateLaunchd (){
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
    <plist version=\"1.0\">
    <dict>
        <key>Disabled</key>
        <false/>
        <key>Label</key>
        <string>tmp_removeframework</string>
        <key>ProgramArguments</key>
        <array>
            <string>$jamf_binary</string>
            <string>removeFramework</string>
        </array>
        <key>RunAtLoad</key>
        <false/>
        <key>StartInterval</key>
        <integer>60</integer>
    </dict>
    </plist>" > /private/tmp/removetools.plist

    chown root:wheel /private/tmp/removetools.plist
    chmod 644 /private/tmp/removetools.plist 

    /bin/launchctl load /private/tmp/removetools.plist
}

CheckBinary
RunRecon
CreateLaunchd
