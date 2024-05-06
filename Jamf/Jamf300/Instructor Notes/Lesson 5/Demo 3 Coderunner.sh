#!/bin/bash

##defaults read ~/Library/Preferences/com.krill.CodeRunner.plist

defaults write ~/Desktop/com.krill.CodeRunner.plist SUEnableAutomaticCheck -boolean true
plutil -convert xml1 ~/Desktop/com.krill.CodeRunner.plist