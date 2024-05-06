#!/bin/bash
#!/bin/bash

#sudo launchctl unload /Library/LaunchDaemons/com.code42.service.plist 
#sudo chflags noschg /Applications/Code42.app
#sudo chmod -R 755 "/Library/Application Support/CrashPlan/" 
#
#
#if [ -e /Applications/Code42.app/Contents/Helpers/Uninstall.app/Contents/Resources/uninstall.sh ]; then
#	sudo /Applications/Code42.app/Contents/Helpers/Uninstall.app/Contents/Resources/uninstall.sh
#else
#	sudo /Library/Application\ Support/CrashPlan/uninstall.sh
#fi
#
#
#exit 0

# The section below uninstalls Code42, if it is installed on the system.
if [[ -e /Library/Application\ Support/CrashPlan/ ]]; then
	launchctl unload /Library/LaunchDaemons/com.crashplan.engine.plist
	launchctl unload /Library/LaunchDaemons/com.code42.service.plist
	/Library/Application\ Support/CrashPlan/uninstall.sh --preserve-data-upgrade
	# versions prior to 12.2.0 will need the below line un-commented
	# /Applications/Code42.app/Contents/Helpers/Uninstall.app/Contents/Resources/uninstall.sh --preserve-data-upgrade
fi

# The section below removes the Code42 identity file. Uncomment the lines below if you wish to do a complete uninstall.
# rm -r /Library/Application\ Support/CrashPlan/