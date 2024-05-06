#!/bin/bash

systemApps="/System/Applications/*.app"
rootApps="/Applications/*.app"

for apps in $systemApps $rootApps;do
	#echo "$apps"
	#echo "$(basename "$apps")"
	#echo "$(basename "$apps")" >> ~/Desktop/myapps.txt
	echo "$(basename "$apps")," >> ~/Desktop/myapps.txt
	#sleep 1
done

cat < /Users/localadmin/Desktop/myapps.txt