#!/bin/bash
result="UNKNOWN"
if [ -e /usr/local/ec/bin/python3 ]; then
	result="Present"
else
	result="Not Present"
fi
echo "<result>$result</result>"