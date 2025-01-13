#!/bin/bash

#fdesetup 
#fdesetup help
#fdesetup status
#fdesetup status | awk '/FileVault is/{print $3}'
#fdesetup status | awk '/FileVault is/{print $3}' | tr -d .
#EA For Filevault Status
fvStatus=$(fdesetup status | awk '/FileVault is/{print $3}' | tr -d .)
echo "<result>$fvStatus</result>"