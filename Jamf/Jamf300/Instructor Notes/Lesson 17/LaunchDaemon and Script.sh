#!/bin/bash


scriptPath="/Users/Shared/anyOrgPropertyList.sh"
plistPath="/Library/LaunchDaemons/com.jamf.demo20.plist"

#########Make a script 
cat > "$scriptPath" << "LOL"
currentOS=$(sw_vers -productVersion)

plistOS=$(defaults read /Users/Shared/com.myOS.mac.plist myOS)
if [[ "$currentOS" != "$plistOS" ]];then 
	jamf recon
	jamf policy -event osupdate
	
else
	echo "They are the same."
fi
LOL
#####change script permissions
chmod 644 "$scriptPath"
chown root:wheel "$scriptPath"

############

###Unload the daemon###
if [[ -f $plistPath ]];then
	sudo launchctl bootout system "$plistPath"
	rm -f "$plistPath"
else
	echo "No file found."
fi


############Make a launch daemon
cat > $plistPath << BRB
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.jamf.demo20</string>
	<key>ProgramArguments</key>
	<array>
		<string>/bin/bash</string>
		<string>/Users/Shared/checkmyos.sh</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>StartInterval</key>
	<integer>86400</integer>
</dict>
</plist>
BRB

####CHange Permissions and ownership

chmod 644 "$plistPath"
chown root:wheel "$plistPath"

####Load the process
sudo launchctl bootstrap system "$plistPath"