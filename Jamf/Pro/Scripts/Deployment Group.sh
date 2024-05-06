#!/bin/bash
#
#
#
# Assigns a  number between 1 and 5 to a computer based off the UUID.  This is useful for rolling out policies
#
#
UUID=$(ioreg -d2 -c IOPlatformExpertDevice | awk -F\" '/IOPlatformUUID/{print $(NF-1)}' | sed 's/[^0-9]*//g' | sed 's/^0*//')
i="5"
DOW=$(date +%u)
while (( "$UUID" % "$i" != 0 ))
do
    i=$((i-1))
done
    echo "<result>$i</result>"
