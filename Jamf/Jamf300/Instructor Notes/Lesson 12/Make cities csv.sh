#!/bin/bash

#echo -n "jamfadmin:jamf1234" > ~/Desktop/mycreds.txt
#Read data to standard output
#cat < /Users/Shared/Resources/Docs/deviceAssignment.csv

#read < /Users/Shared/Resources/Docs/deviceAssignment.csv

#cat < /Users/Shared/Resources/Docs/deviceAssignment.csv\


#cat > ~/Desktop/cities.csv << CHESTER
#Broussard,
#Youngsville,
#Lafayette
#CHESTER

#cat > ~/Desktop/example.csv << HERE
#Broussard,100,42,
#Youngsville,99,55,
#Lafayette,5,66,
#HERE


#cat > ~/Desktop/com.example.lesson.plist << LAUNCH
#<?xml version="1.0" encoding="UTF-8"?>
#<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://#www.apple.com/DTDs/PropertyList-1.0.dtd">
#<plist version="1.0">
#<dict>
#	<key>Label</key>
#	<string>com.example.lesson</string>
#	<key>ProgramArguments</key>
#	<array>
#		<string>/usr/bin/open</string>
#		<string>https://jamf.it/courseresources</string>
#	</array>
#	<key>RunAtLoad</key>
#	<true/>
#</dict>
#</plist>
#LAUNCH

cat > /Users/Shared/example.sh << SCRIPT
#!/bin/bash
date > ~/Desktop/myfile.txt
SCRIPT