#!/bin/bash

currentOS=$(sw_vers -productVersion)

if [[ "$currentOS" > "13" ]];then
	echo "Greater that 13"
else
	echo "Less than or equal to 13."
fi