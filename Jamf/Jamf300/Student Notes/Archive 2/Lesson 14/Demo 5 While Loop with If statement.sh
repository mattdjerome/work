#!/bin/bash

loop=0
while [[ -d /Applications/Google\ Chrome.app/ ]];do
	echo "The app is here. It must go!"
	((loop++))
	echo "The loop count is at: $loop"
	#sleep 3 
	if [[ "$loop" -gt "10" ]];then
		echo "I guess we will just keep google here."
		exit
		
	else
		echo "Keep Going."
	fi
done
echo "It looks like Google Chrome is gone. Great job."