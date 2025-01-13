#!/usr/local/ec/bin/python3
'''
Check for presence of C42 Full Disk Access profile
ToddM, 6/13/22
updated to check for Code42 Incydr Basic and Advanced 
mjerome 01/31/2023
'''

# jamf_check_c42_fda_profile.py ################################################
#
#   Check for presence of C42 Full Disk Access profile
#
################################################################################

# Notes: #######################################################################
#
# _computerlevel[2] attribute: name: Code42 Incydr Basic and Advanced
# _computerlevel[2] attribute: configurationDescription:
# _computerlevel[2] attribute: installationDate: 2022-10-10 20:43:13 +0000
# _computerlevel[2] attribute: organization: Emerson Collective
# _computerlevel[2] attribute: profileIdentifier: B0321509-0171-4BDC-9C36-F0F1D5970A9A
# _computerlevel[2] attribute: profileUUID:       B0321509-0171-4BDC-9C36-F0F1D5970A9A
# _computerlevel[2] attribute: profileType: com.apple.TCC.configuration-profile-policy
# _computerlevel[2] attribute: removalDisallowed: TRUE
# _computerlevel[2] attribute: version: 1
# _computerlevel[2] attribute: containsComputerItems: TRUE
# _computerlevel[2] attribute: installedByMDM: TRUE
#_computerlevel[7] payload count = 2
#_computerlevel[7]            payload[1] name			= Custom Settings
#_computerlevel[7]            payload[1] description		= (null)
#_computerlevel[7]            payload[1] type			= com.apple.ManagedClient.preferences
#_computerlevel[7]            payload[1] organization		= JAMF Software
#_computerlevel[7]            payload[1] identifier		= 90849496-BFDC-4AB2-8DC6-DB32E2C165BA
#_computerlevel[7]            payload[1] uuid			= 90849496-BFDC-4AB2-8DC6-DB32E2C165BA
#_computerlevel[7]            payload[2] name			= Code42 Incydr Basic and Advanced
#_computerlevel[7]            payload[2] description		= Code42 Incydr Basic and Advanced
#_computerlevel[7]            payload[2] type			= com.apple.TCC.configuration-profile-policy
#_computerlevel[7]            payload[2] organization		= Code42 Software
#_computerlevel[7]            payload[2] identifier		= 978BC9AC-1441-45B3-B4BF-9953CC71F566
#_computerlevel[7]            payload[2] uuid			= 993DC3DE-F938-4E2E-BE36-9E442EC081D3
##
################################################################################

# TTD: #########################################################################
#
#
#
################################################################################

import subprocess


def main():
    '''
    Check for presence of C42 Full Disk Access profile
    '''
    target_profile_uuid = 'B0321509-0171-4BDC-9C36-F0F1D5970A9A'

    raw_profiles = subprocess.check_output(["profiles", "list"]).decode('utf-8')
    profile_present = target_profile_uuid in raw_profiles

    print("<result>" + str(profile_present) + "</result>")


if __name__ == '__main__':
    main()
    