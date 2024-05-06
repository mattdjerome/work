#!/bin/bash
mkdir ~/Pictures/mess

for png in ~/Desktop/*.png;do
	#echo "$png"
	echo "I found: $(basename "$png")"
	mv "$png" ~/Pictures/mess
	#sleep 1
done