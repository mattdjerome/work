#!/bin/bash

initial_setup_date=$(date "+%Y-%m-%d")
current_user=$(ls -l /dev/console | awk '{print $3}')
defaults write /Users/$current_user/Library/Preferencs/com.ec.plist initial_setup_date -date $initial_setup_date
read_setup_date=$(defaults read /Users/$current_user/Library/Preferencs/com.ec.plist initial_setup_date)
echo $read_setup_date


