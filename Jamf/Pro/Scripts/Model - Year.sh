#!/bin/bash

# Determine the model and year:
DEIVCE_IDENTIFIER=$(sysctl hw.model | awk '{print $NF}')
DEVICE_MODEL_CURL=$(curl -s "https://raw.githubusercontent.com/quacktacular/mac-device-id-to-model/main/models.txt" | grep "$DEIVCE_IDENTIFIER")
if [[ $DEVICE_MODEL_CURL = *"("*")"* ]]; then
	DEVICE_MODEL=$( echo $DEVICE_MODEL_CURL | cut -f1 -d"|" ) 
	DEVICE_YEAR=$( echo "$DEVICE_MODEL" | grep -o -E '[0-9][0-9][0-9][0-9]' )
else
#	DEVICE_MODEL="Unknown Mac"
	DEVICE_YEAR="N/A"
fi

# Now you can use the variables:
echo "<result>$DEVICE_YEAR</result>"
