#!/bin/bash
# set -x

##############################################################################################################
# Script Name:  incydr_lasttransmit.sh
# By:  Perrin Bishop-Wright / Created:  8/16/2022
# Version:  1.0.1 / Updated:  9/13/2022 / By:  PBW
#
# Description:  This script checks to see if the macOS endpoints (macOS 11 and higher) has the proper MDM settings for Code42 Incydr
#				applicatoin (Code42-AAT.app) - Professional, Enterprise, Horizon, and Gov F2. 
##############################################################################################################


## If capturing local logs specify the path below. If not change "locally_log" to false. 
locally_log="false"
local_logs="/opt/ManagedFrameworks/EA_History.log"

write_to_log() {
	
	# Arguments
	# $1 = (str) Message that will be written to a log file
	
	local message="${1}"
	
	if [[ "${locally_log}" == "true" ]]; then
		
		if [[ ! -e "${local_logs}" ]]; then
			
			bin/mkdir -p "$( /usr/bin/dirname "${local_logs}" )"
			/usr/bin/touch "${local_logs}"
			
		fi
		
		time_stamp=$( /bin/date +%Y-%m-%d\ %H:%M:%S )
		echo "${time_stamp}:  ${message}" >> "${local_logs}"
		
	fi
	
}

report_result() {
	
	# Arguments
	# $1 = (str) Message that will be written to a log file
	
	local message="${1}"
	
	## If capturing local logs specify the message. If not comment out the line below. 
	write_to_log "C42 Last Transmit:  ${message}"
	## JAMF Extension Attribute direction. If not comment out the line below. 
	echo "<result>${message}</result>"
	exit 0
	
}

last_transmit=$(grep "message_tran | Transmitted" /Library/Application\ Support/Code42-AAT/logs/code42-aat.log |tail -1 | awk '{print $1}')

report_result "$last_transmit"