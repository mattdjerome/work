#!/bin/bash
##################################################################
#: Date Created  : (Apr 01, 2019 )
#: Author        : Daniel Griggs
#: Email         : dan@cmdsec.com
#: Version       : 0.10
##################################################################


######################
### VARIABLE BLOCK ###
######################
SERIAL_NUMBER=$(system_profiler SPHardwareDataType | grep 'Serial Number (system)' | awk '{print $NF}')
GUI_USER=$(who | grep console | grep -v '_mbsetupuser' | awk '{print $1}')
######################
# END VARIABLE BLOCK #
######################
#
#
#
######################
### FUNCTIONS BLOCK ###
######################
get_user_first_name(){
  echo "Starting get_user_first_name"
  userFullName=$(dscl . read /Users/"$GUI_USER" RealName | tail -1 | cut -d" " -f2-)
  echo "Full Name:$userFullName"
  userFirstName=$(echo "$userFullName" | awk '{print $1}')
  echo "First Name:$userFirstName"
}

set_computer_name(){
  echo "Starting set_computer_name"
  scutil --set ComputerName "$userFirstName-$SERIAL_NUMBER"
  scutil --set HostName "$userFirstName-$SERIAL_NUMBER"
  scutil --set LocalHostName "$userFirstName-$SERIAL_NUMBER"
}

######################
# END FUNCTIONS BLOCK #
######################
get_user_first_name

case $userFullName in
*[aA]dmin*)
	echo "Admin account logged in, exiting"
	exit 0
	;;
*[sS]etup*)
	# _mbsetupuser full Name is "Setup User"
	echo "Computer still in setup, exiting"
	exit 0
	;;
*)
	echo "Proper user, continuing"
	set_computer_name

	echo "ComputerName:$(scutil --get ComputerName)"
	echo "HostName:$(scutil --get HostName)"
	echo "LocalHostName:$(scutil --get LocalHostName)"
	;;
esac

echo "## New Settings ##"
echo "ComputerName:$(scutil --get ComputerName)"
echo "HostName:$(scutil --get HostName)"
echo "LocalHostName:$(scutil --get LocalHostName)"
echo "##################"
























#end

