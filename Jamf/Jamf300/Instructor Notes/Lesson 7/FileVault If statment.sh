#!/bin/bash

fvStatus=$(fdesetup status | awk '/FileVault is/{print $3}' | tr -d .)
if [[ $fvStatus == "Off" ]];then
	echo "Turn on FileVault"
	open -a "Self Service.app"
else
	echo "FileVault is on. You are good to go. Be well."
fi