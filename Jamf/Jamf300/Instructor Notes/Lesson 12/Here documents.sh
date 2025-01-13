#!/bin/bash

#read < /Users/localadmin/Desktop/example.csv
#read bldg < /Users/localadmin/Desktop/example.csv
#echo "$bldg"

#read bldg id room < /Users/localadmin/Desktop/example.csv
#echo $bldg $id $room

IFS=,
read bldg id room < /Users/localadmin/Desktop/example.csv
echo $bldg 
echo $id 
echo $room