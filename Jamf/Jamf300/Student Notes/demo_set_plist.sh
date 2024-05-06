#!/bin/bash

# Create a plist for the size of the coffee
defaults write ~/Desktop/com.demo.coffee.plist size -integer 12

#Creates another key for the type of coffee
defaults write ~/Desktop/com.demo.coffee.plist coffeeType -string Starbucks

defaults write ~/Desktop/com.demo.coffee.plist everyDay -boolean true


# Above creates it as a binary. Need to convert it from binary to xml using plutil
plutil -convert xml1 ~/Desktop/com.demo.coffee.plist

