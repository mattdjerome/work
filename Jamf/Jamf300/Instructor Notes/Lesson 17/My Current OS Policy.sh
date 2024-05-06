#!/bin/bash

currentOS=$(sw_vers -productVersion)

defaults write /Users/Shared/com.myOS.mac.plist myOS $currentOS