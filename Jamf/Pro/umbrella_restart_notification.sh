
#!/bin/bash

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
windowType="hud"
description="In order to finish installing the new Fanatics security software (Cisco Umbrella), a reboot is necessary

Please save all working documents before continuing.

This will only take about 5 minutes. If no action is taken in 5 minutes, your computer will restart."


button1="Reboot"
icon="/tmp/lock_icon.png"
title="Cisco Umbrella Installation"
alignDescription="left" 
alignHeading="center"
defaultButton="2"
timeout="900"

# JAMF Helper window as it appears for targeted computers
userChoice=$("$jamfHelper" -windowType "$windowType" -lockHUD -title "$title" -timeout "$timeout" -defaultButton "$defaultButton" -icon "/Library/Fanatics/Fanatics_icon.png" -description "$description" -alignDescription "$alignDescription" -alignHeading "$alignHeading" -button1 "$button1" -showDelayOptions "0, 600, 1200, 3600, 7200" -timeout 300 -countdown)

case $userChoice in
	6001)
		dialog --title "Restart Timer" --subtitle "Your computer will restart in 10 minutes" --message "Your computer is pending a restart in 10 minutes." --style mini --icon "/Library/Fanatics/Fanatics_icon.png" --timer 600 --ontop --moveable --position topright
	;;
	12001)
		dialog --title "Restart Timer" --subtitle "Your computer will restart in 20 minutes" --message "Your computer is pending a restart in 20 minutes."--style mini --icon "/Library/Fanatics/Fanatics_icon.png" --timer 1200 --ontop --moveable --position topright
	;;
	36001)
		dialog --title "Restart Timer" --subtitle "Your computer will restart in 1 hour" --message "Your computer is pending a restart in 1 hour" --style mini --icon "/Library/Fanatics/Fanatics_icon.png" --timer 3600 --ontop --moveable --position topright
	;;
	72001)
		dialog --title "Restart Timer" --subtitle "Your computer will restart in 2 hours" --message "Your computer is pending a restart in 2 hours." --style mini --icon "/Library/Fanatics/Fanatics_icon.png" --timer 7200 --ontop --moveable --position topright
	;;
	243)
#		shutdown -r now
		echo "shutdown now"
	;;
	*)
		shutdown -r now
	;;
esac
dialog --title "Restart Timer" --style mini --message "Your computer will restart now to complete the Cisco Umbrella installation." --icon "/Library/Fanatics/Fanatics_icon.png" --button1text "Restart" --ontop --moveable --position center
shutdown -r now