#!/bin/bash

#Step 1
#fdesetup # this will fail b/c it needs parameters
#fdesetup help #gives the help page
fdesetup status
fdesetup status | awk '/FileVault is/{print $3}' # awk is pattern oriented. look for the pattern. this says, look for filevault is and get the 3rd item.
fvStatus=$(fdesetup status | awk '/FileVault is/{print $3}' | tr -d .) #tr means translate one character to another. -d with tr says delete from standard output, tr bob hope, translate bob to hope
echo "<result>$fvStatus</result>"