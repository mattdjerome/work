#!/bin/bash

org=$(grep "org=" /Library/Logs/Crashplan/app.log)
IFS=',' read -r -a array <<< "$org"
#echo "${array[4]:12}"
org_name=${array[4]:12}
echo "<result>$org_name</result>"