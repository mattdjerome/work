#!/bin/bash


# MDM Profile	00000000-0000-0000-A000-4A414D460003	
### Profile that needs to be removed, can't remove it directly
# High Sierra FileVault Encryption	E3BABE92-4702-4136-8AD2-8F1D8E14E52F
# 

sudo profiles remove -identifier 00000000-0000-0000-A000-4A414D460003
sudo profiles remove -identifier E3BABE92-4702-4136-8AD2-8F1D8E14E52F

/usr/local/bin/jamf mdm
/usr/local/bin/jamf manage
