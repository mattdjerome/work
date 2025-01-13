#!/bin/bash

defaults write ~/Desktop/com.apple.safari.plist ShowFullURLInSmartSearchField -boolean true
plutil -convert xml1 ~/Desktop/com.apple.safari.plist