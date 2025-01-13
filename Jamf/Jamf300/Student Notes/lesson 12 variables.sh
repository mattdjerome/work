#!/bin/bash


# use > to overwrite and >> to append using here documents. the middle is the here part
#cat >> ~/Desktop/cities.csv << CHESTER
#Broussard,100,42
#Youngsville,99,55
#Lafayette,5,66
#CHESTER
#
##use cat with plists
#
#cat > ~/Desktop/com.demo.coffee.plist << LAUNCH
##PUT XML STUFF HERE TO MAKE PLIST
#LAUNCH


##READ in a data from a file with the read command

#IFS is an internal field seperator. This says the seperator is a comma and then read the value in each column. This does all columns in first row. requires a loop for that
#IFS=,
#read bldg id room < ~/Desktop/cities.csv
#echo $bldg $id $room
#

# -j days don't try to set the date -f says in secords using %s, +%F formats the full date/time 
bootTime=$(sysctl kern.boottime | awk '{print $5}' | tr -d ,)

echo "$bootTime"

bootTimeFormatted=$(date -jf %s $bootTime +%F\ %T)
echo $bootTimeFormattedecho "<result>$bootTimeFormatted</result>"
