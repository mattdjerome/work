#!/bin/bash

#Make an agent. 
#Step 1: Make a label.
defaults write ~/Desktop/com.jamf.demo1.plist Label com.jamf.demo1

#Step 2: Have it do something

defaults write ~/Desktop/com.jamf.demo1.plist ProgramArguments -array "/usr/bin/open" "https://jamf.it/courseresources"

#Step 3 Extra stuff 
defaults write ~/Desktop/com.jamf.demo1.plist RunAtLoad -boolean true