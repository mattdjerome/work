#!/bin/bash

#Integer
defaults write ~/Desktop/com.demo.coffee.plist size -integer 12
#String
defaults write ~/Desktop/com.demo.coffee.plist coffeType -string Starbucks
#Boolean
defaults write ~/Desktop/com.demo.coffee.plist everyDay -boolean true
#Convert from binary to XML
plutil -convert xml1 ~/Desktop/com.demo.coffee.plist