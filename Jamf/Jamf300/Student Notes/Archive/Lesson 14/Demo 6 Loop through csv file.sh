#!/bin/bash

IFS=,
while read bldg id room;do
#echo $bldg 
#echo $id 
#echo $room
	echo "My computer is id: $id in Building: $bldg in Room Number: $room"
	sleep 1

done < /Users/localadmin/Desktop/example.csv