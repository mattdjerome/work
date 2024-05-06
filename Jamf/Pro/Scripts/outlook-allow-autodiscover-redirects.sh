#!/bin/bash

GUI_USER=$(who | grep console | grep -v '_mbsetupuser' | awk '{print $1}') 

sudo -u $GUI_USER /usr/bin/defaults write com.microsoft.Outlook TrustO365AutodiscoverRedirect -bool true
