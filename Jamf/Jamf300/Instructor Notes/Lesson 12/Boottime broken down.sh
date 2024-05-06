#!/bin/bash

#man sysctl
#sysctl kern.boottime

#sysctl kern.boottime | awk '{print $5}'

#sysctl kern.boottime | awk '{print $5}' | tr -d ,

bootTime=$(sysctl kern.boottime | awk '{print $5}' | tr -d ,)
#echo "$bootTime"

bootTimeFormatted=$(date -jf %s $bootTime +%F\ %T)
echo "<result>$bootTimeFormatted</result>"