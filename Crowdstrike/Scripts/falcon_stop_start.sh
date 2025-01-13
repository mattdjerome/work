#!/bin/bash

/Applications/Falcon.app/Contents/Resources/falconctl unload
echo "Exit Code is $?"
/Applications/Falcon.app/Contents/Resources/falconctl load
echo "Exit Code is $?"