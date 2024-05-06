#!/bin/bash
##################################################################
#: Date Created  : (December 30, 2014)
#: Author        : Daniel Griggs
#: Version       : 1.00
##################################################################


cat /var/log/jamf.log |
grep -i Policy |
grep -v "Update Inventory\|Enable Locked out" |
grep -i "executing" |
tail -10 > ~/output.txt

open ~/output.txt

