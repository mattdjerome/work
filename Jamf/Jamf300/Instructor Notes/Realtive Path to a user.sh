#!/bin/bash

me=$(whoami)
currentUser=$(stat -f%Su /dev/console)
echo "/Users/$me/Desktop"
echo "/Users/$currentUser/Desktop"