#!/bin/bash

#display dialog "My First Message" buttons {"OK"} default button 1

#osascript -e 'display dialog "My First Message" buttons {"OK"} default button 1'

#osascript -e 'button returned of(display dialog "My First Message" buttons {"OK"} default button 1)'

#myButton=$(osascript -e 'button returned of(display dialog "My First Message" buttons {"OK"} default button 1)')
#if [[ "$myButton" == "OK" ]];then
	#echo "Do the thing. "
#else
#	echo "Don't do the thing."
#fi

#myButton=$(osascript -e 'button returned of(display dialog "My First Message" buttons {"NO","OK"} default button 1)')
#if [[ "$myButton" == "OK" ]];then
#	echo "Do the thing. "
#else
#	echo "Don't do the thing."
#fi

myButton=$(osascript -e 'button returned of(display dialog "My First Message" buttons {"NO","OK","Maybe"} default button 1)')
if [[ "$myButton" == "Maybe" ]];then
	echo "I might don the thing. Who knows. "
else
	echo "Don't do the thing."
fi