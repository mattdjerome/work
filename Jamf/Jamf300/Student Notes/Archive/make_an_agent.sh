#!/bin/bash

#Step 1 make an agent
defaults write ~/Desktop/com.jamf.demo1.plist Label com.jamf.demo1

#Step 1=2: Have it do something
#In this case, open course resources, requires an array use ProgramArguments and -array
defaults write ~/Desktop/com.jamf.demo1.plist ProgramArguments -array "/usr/bin/open" "https://jamf.it/courseresources"

#Step 3 Extra Stuff, adding RunAtLoad to start it when the system starts. RunatLoad vs Startup. It must be loaded to memory before it can run, that why RunAtLoad is used aka bootstrapping. Starting means it performs the action. RunAtLoad is an immediate action
defaults write ~/Desktop/com.jamf.demo1.plist RunAtLoad -boolean true