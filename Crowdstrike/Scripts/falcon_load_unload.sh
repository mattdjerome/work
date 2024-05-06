#!/bin/bash

echo "Unloading Sensor"
sudo /Applications/Falcon.app/Contents/Resources/falconctl unload > /dev/null
unload_return=$(echo $?)


if [ ! $unload_return ];
then
    echo "unload failure, exiting"; exit
fi
echo "Loading Sensor"
sudo /Applications/Falcon.app/Contents/Resources/falconctl load > /dev/null 2>&1
load_return=$(echo $?)

if [ $load_return ];
then
    echo "load failure, exiting"; exit
    #reinstalling falcon b/c of failed exit code using jamf custom trigger.
    echo "This is where I'd re-run the policy"
    #jamf policy -trigger reinstall_falcon
fi

echo "Process Complete."