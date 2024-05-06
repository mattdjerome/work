#!/bin/bash
##################################################################
#: Date Created  : (May 27, 2017)
#: Author        : Daniel Griggs
#: Email         : dan@cmdsec.com
#: Version       : 0.20
##################################################################


######################
### VARIABLE BLOCK ###
######################


# manual triggers to run when calling jamf
# Format is 'DISPLAY_NAME;TRIGGER_NAME'
POLICY_TRIGGERS_TO_RUN=( 'Slack:installSlack'
'Box Drive:installBoxDrive'
'Box Supporting Tools:installBoxEdit'
'Box Notes:installBoxNotes'
'Firefox:installFirefox'
'Slack:installSlack'
'Crashplan:installCrashplan'
'Microsoft Office:installOffice'
'Google Chrome:installChrome' )

# Get total triggers to display progress to the user
TOTAL_STEPS=$(echo "${#POLICY_TRIGGERS_TO_RUN[@]}")


######################
# END VARIABLE BLOCK #
######################
#
#
#
######################
### FUNCTIONS BLOCK ###
######################
inital_setup_clean_up_host(){
	echo "##### Starting inital_setup_clean_up_host"

	# Setup and ensure that all of the old policies from the old enrollment are not present
  # /usr/local/bin/jamf flushPolicyHistory

	#set pmset to avoid screen going dark or drive spinning down while imaging
	/usr/bin/pmset -b displaysleep 20
	/usr/bin/pmset -a displaysleep 20 disksleep 20

	echo "##### Finished inital_setup_clean_up_host"
	echo " "
}

check_jss_connection(){
	# actually run the command to check the jss connection
  unset jssStatus
  local pingJSS=$(/usr/local/bin/jamf checkJSSConnection -retry 1)
  # echo "$pingJSS" >> /var/cmdSec/first-boot-imaging.log

  if [[ $pingJSS =~ "The JSS is available." ]]; then
    jssStatus="0"
  else
    jssStatus="1"
  fi
}

wait_for_jamf_connection(){
  # Logic to hold the script until the jss is available

  check_jss_connection
  local waitLimit=300
  local waitIncrement=20

  while [[ $jssStatus != 0 ]]
  do
    if [[ $waitLimit -gt 1 ]]; then
      echo "sleep loop, $waitLimit seconds until timeout" >> /var/cmdSec/first-boot-imaging.log
      /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -windowPosition 'lr' -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ConnectToIcon.icns" -heading "Initial Setup" -description "Could not connect to JSS, waiting $waitIncrement seconds to try again. $waitLimit seconds until timeout

Please connect your computer to the internet if it isn't already" &

      sleep $waitIncrement
      waitLimit=$(expr $waitLimit - $waitIncrement)
      check_jss_connection

      killall jamfHelper
    else
      echo "could not connect to jss, exiting"
      /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ConnectToIcon.icns" -heading "Management Server Error" -description "Could NOT connect to the management server

Please contact the helpdesk"
      sleep 300
      killall jamfHelper
    fi
  done
  killall jamfHelper

}


drop_jamf_progress_window(){
	echo "##### Starting drop_jamf_progress_window"

  /usr/bin/killall jamfHelper

  /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -windowPosition 'lr' -icon "/System/Library/CoreServices/Install in Progress.app/Contents/Resources/Installer.icns" -heading "Initial Software Setup" -description "You can use the computer normally during this process.

Installing: $1.
Step $2 of $TOTAL_STEPS" &

	echo "##### Finished drop_jamf_progress_window"
	echo " "
}

call_jamf_to_run_policy(){
	echo "##### Starting call_jamf_to_run_policy"

  /usr/local/bin/jamf policy -event "$1" &
  wait $!
	# local exitCode=$(echo $?)
  #
	# # If the first try failed, wait 20 secs and try again
	# if [[ $exitCode != 0 ]]; then
	# 	echo "## JAMF command failed"
	# 	sleep 5
	# 	echo "## Trying again"
	# 	unset exitCode
  #
	# 	/usr/local/bin/jamf policy -event "$1"
	# 	local exitCode=$(echo $?)
  #
	# 	# If the second time fails, append the name to the failed array and give up
	# 	if [[ $exitCode != 0 ]]; then
	# 		checkOutput=("${checkOutput[@]}" "Policy $1 failed")
	# 	fi
  #
  #
	# fi


  #### error handling ####

	unset exitCode
	echo "##### Finished call_jamf_to_run_policy"
	echo " "
}



######################
# END FUNCTIONS BLOCK #
######################



main(){

	inital_setup_clean_up_host

	wait_for_jamf_connection

  for ((i = 0; i < ${#POLICY_TRIGGERS_TO_RUN[@]}; i++))
	# Loop through all of the custom triggers and run them
  do
  	echo "Evaluating: ${POLICY_TRIGGERS_TO_RUN[$i]}"
    local displayName=$(echo "${POLICY_TRIGGERS_TO_RUN[$i]}" | cut -d':' -f1) # what to show the user
    local triggerName=$(echo "${POLICY_TRIGGERS_TO_RUN[$i]}" | cut -d':' -f2) # custom trigger to run
    local stepNumber=$(($i +1)) # add 1 so we don't 'step 0' to the user

    # Show the user
    drop_jamf_progress_window "$displayName" "$stepNumber"

    # Call jamf to do the work
    call_jamf_to_run_policy "$triggerName"

    # Sleep just to make sure that everything closed
    sleep 1
    /usr/bin/killall jamfHelper

    unset displayName
    unset triggerName
    unset stepNumber
  done

	if [[ ${#checkOutput[@]} -gt 0 ]]; then
		# Script has failed policy actions
		printf '%s\n' "<result>${checkOutput[@]}</result>"
		exit 1
		#statements
	fi

}


main

