#!/bin/bash
description="Emerson collective IT updated a security component of your computer, please restart within the next 8 hours to complete the update.

Please email ithelp@emersoncollective.com with any questions or concerns.

Your computer will restart in 15 minutes unless a deferral is selected."
helper_response=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -countdown -timeout 900 -showDelayOptions "0, 1800, 3600, 7200, 14400, 28800" -title "From Emerson Collective IT" -alignCountdown center -icon "/Library/EC/logo.icns" -alignDescription justified -heading "Your Computer Needs To Restart" -button1 "Restart" -lockHUD -description "$description" -windowType hud -defaultButton 1)
if [ $helper_response == 1 ]; then
	echo "Restart Now"
	sudo shutdown -r now
elif [ $helper_response == 18001 ]; then
	echo "restart in 30 minutes"
	shutdown -h +30
elif [ $helper_response == 36001 ]; then
	echo "restart in 1 hour"
	shutdown -h +60
elif [ $helper_response == 72001 ]; then
	echo "restart in 2 hours"
	shutdown -h +120
elif [ $helper_response == 144001 ]; then
	echo "restart in 4 hours"
	shutdown -h +240
elif [ $helper_response == 288001 ]; then
	echo "restart in 8 hours"
	shutdown -h +480
fi
