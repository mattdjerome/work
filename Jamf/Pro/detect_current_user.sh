#!/bin/bash

# Checking if Setup Manager has been run. If the user data file exists, it grabs the userID information and assigns it to the user in Jamf
if [[ -e /private/var/db/.JamfSetupEnrollmentDone ]]; then
	echo "Setup manager complete file found"
	if [[ -e /private/var/db/SetupManagerUserData.txt ]]; then
		user=$(awk -F ': ' '/userID: / {print $2}' /private/var/db/SetupManagerUserData.txt)
		echo "Setup manager user data file found"
		if [[ -n $user ]] && [[ "$user" != "itsupport" ]]; then
			jamf recon -endUsername $user
			exit 0
		fi
	else
		echo "setup manager user data file not found"
	fi
fi

# Check the local Microsoft account,
echo "Username not found, continuing to check office activation email"
currentUser=$(stat -f "%Su" /dev/console)
echo "current user is $currentUser"
if [[ $currentUser != "itsupport" ]] ; then
	echo "checking office activation email"
	officeEmail=$(defaults read /Users/$currentUser/Library/Preferences/com.microsoft.office.plist OfficeActivationEmailAddress)
	#Checking if office email is empty/not signed in, if not signed in, exit 1 else use that as the username in jamf
	if [[ -n $officeEmail ]]; then # checks if length of office activation email is not 0, meaning there's an email present
		echo "Office activation email is $officeEmail"
		echo "Adjusting office activation email to be only the username (removing email domain)"
		usernameOnly=$(echo "$officeEmail" | cut -f1 -d"@")
		echo "username is $usernameOnly"
		jamf recon -endUsername $usernameOnly
		exit 0
	fi
elif [[ $currentUser == "itsupport" ]]; then
	echo "current user is $currentUser, exiting"
	exit 1
fi

# Final check is if Jamf connect is signed in, if yes, use that email to assign computer to user
	
echo "havent found a user, checking jamf connect"
currentUser=$(defaults read /Users/$currentUser/Library/Preferences/com.jamf.connect.state.plist UserEmail)
if [[ $currentUser != "" ]]; then # Checks if connect user name is empty or not
	echo "username found, assigning to user $currentUser"
	echo "Adjusting jamf connect email to be only the username (removing email domain)"
	usernameOnly=$(echo "$currentUser" | cut -f1 -d"@")
	jamf recon -endUsername $usernameOnly
	exit 0
fi

echo "no valid username found, exiting"
exit 1