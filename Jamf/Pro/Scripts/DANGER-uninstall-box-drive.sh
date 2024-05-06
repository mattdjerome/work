#!/bin/bash

GUI_USER=$(who | grep console | grep -v '_mbsetupuser' | awk '{print $1}') 

# Find any open files
boxDriveFolder=$(find "/Users/$GUI_USER" -maxdepth 2 -name Box)
openFiles=$(lsof "$boxDriveFolder/")
echo "$openFiles"

# uninstall_box_drive -- remove Box Drive components from a machine.
#
# usage: uninstall_box_drive [-n]
#
# options:
#
#   -n      No quit if FUSE is unable to be uninstalled (for AAU)
#
# This script must be run as a regular user, not with elevated privileges. And other
# than the 'sudo' call to run the "uninstall_box_drive_r" script, no further uses of sudo
# should appear in this script. Anything that requires sudo should go in "uninstall_box_drive_r"
#
# Possible exit codes:
#
#   0   - Success
#   1   - Was run with elevated privilege
#   2   - Was unable to unload the FUSE kext
#   3   - Box.app is running.
#   4   - Unknown parameter
#

BFD_IDENTIFIER="com.box.desktop"
BOX_HELPER_IDENTIFIER=com.box.desktop.helper
BOX_HELPER_PLIST_PATH=/Library/LaunchAgents/$BOX_HELPER_IDENTIFIER.plist
FINDER_EXTENSION_IDENTIFIER=com.box.desktop.findersyncext

#
# Return 1 if an app with the specified bundle ID is running
#
function is_app_running {
    /usr/bin/lsappinfo find kLSBundleIdentifierLowerCaseKey="$1" | grep -c ASN
}


#
# Exit the script with a message if we're running as root
#
function ensure_running_as_user {
    if [ $EUID -eq 0 ]; then
        echo "Do not run this script with root privileges. Do not use 'sudo'."
        exit 1
    fi
}


#
# Check and see if Box is running - user will need to quit if it is
#
function ensure_box_not_running {
    if is_app_running $BFD_IDENTIFIER; then
        echo "Box Drive appears to be running. You must quit the Box Drive application and run this script again."
        exit 3
    fi
}

function unload_user_au_and_helper {
    # Unload the user version of the helper
    /bin/launchctl unload $BOX_HELPER_PLIST_PATH || true
}


#
# Clear out any prefs we've set
#
function clear_user_level_prefs {
    sudo -u $GUI_USER defaults delete com.box.desktop.installer || true
    sudo -u $GUI_USER defaults delete com.box.desktop.ui || true
    sudo -u $GUI_USER defaults delete com.box.desktop || true
}


#
# In Python _add_to_startup_items() adds Box to System Preferences > Users & Groups > Login Items so reverse this.
#
function remove_from_login_items {
    sudo -u $GUI_USER osascript -e 'tell application "System Events" to delete every login item whose name is "Box"' 2>/dev/null || true
}

#
# Disable the Finder extension
#
function disable_finder_extension {
    # Always disable the plugin
    /usr/bin/pluginkit -e ignore -i $FINDER_EXTENSION_IDENTIFIER || true

    # Immediately kill any running processes
    killall -9 FinderSyncExt || true
}

#
# Delete the Box token from the keychain
#
function delete_box_token {
    sudo -u $GUI_USER /usr/bin/security delete-generic-password -c aapl -s Box || true
}

#
# main
#

#
# A command-line parameter of "-n" means "don't give up if you can't uninstall FUSE."
# This is intended for AAU use.
#



killall Box

# Make sure we're clear to go
# ensure_running_as_user && \
# ensure_box_not_running && \
unload_user_au_and_helper && \
disable_finder_extension

# Do the work that requires sudo - this work is placed in a separate script to support
# developers. In jenkins passwordless sudo is enabled. But on developer machine we
# shouldn't required a blankey "password-less sudo". This is an issue because developers
# run Chimp locally and Chimp executes these uninstall scripts and it's often the case
# that there's no STDIN for sudo to use to get the password. Thus, by placing all the
# logic that requires sudo in a script called uninstall_box_drive_r... the developers
# can add an password-exemption for just that script in /etc/sudoers that looks like:
#     <username> ALL = (root) NOPASSWD: /Library/Application\ Support/Box/uninstall_box_drive_r
#
sudo "${0%/*}/"uninstall_box_drive_r $fuse_failure_quits

# Do any remaining non-sudo work
clear_user_level_prefs
#remove_from_login_items
delete_box_token

echo
echo
echo "* * * * * *"
echo
echo "Box Drive has been uninstalled."
echo
echo "* * * * * *"
echo
echo



#!/bin/bash
#
# uninstall_box_drive_r -- This script is run by its parent script uninstall_box_drive.
#                           It is NOT meant to be run standalone


KEXT_BUNDLE_IDENTIFIER="com.box.filesystems.osxfuse"
BFD_IDENTIFIER="com.box.desktop"
AUTOUPDATER_IDENTIFIER=com.box.desktop.autoupdater
AUTOUPDATER_PLIST_PATH=/Library/LaunchDaemons/$AUTOUPDATER_IDENTIFIER.plist
BOX_HELPER_IDENTIFIER=com.box.desktop.helper
BOX_HELPER_PLIST_PATH=/Library/LaunchAgents/$BOX_HELPER_IDENTIFIER.plist

#
# Return 1 if an app with the specified bundle ID is running
#
function is_app_running {
    /usr/bin/lsappinfo find kLSBundleIdentifierLowerCaseKey="$1" | grep -c ASN
}

#
# Use Spotlight to glean info on locations of Box.app
#
function number_of_box_apps_installed {
    /usr/bin/mdfind -count kMDItemCFBundleIdentifier = $BFD_IDENTIFIER
}

function path_to_first_box_app_found {
    /usr/bin/mdfind kMDItemCFBundleIdentifier = $BFD_IDENTIFIER | head -n 1
}

function number_of_box_apps_in_applications_folder {
    /usr/bin/mdfind kMDItemCFBundleIdentifier = $BFD_IDENTIFIER | grep "^/Applications/" -c
}

function box_app_exists_in_applications_folder {
  [ "$(number_of_box_apps_in_applications_folder)" -gt 0 ]
}

function path_to_box_app_in_applications_folder {
    /usr/bin/mdfind kMDItemCFBundleIdentifier = $BFD_IDENTIFIER | grep "^/Applications/" | head -n 1
}

#
# Where is box.app?
#
# - If /Applications/Box.app exists, use that
# - If Box.app exists in a sub-folder of /Applications, use that
# - If user has only one copy of Box.app on the machine, use that
#
function box_app_path {
    if [ -e "/Applications/Box.app" ]; then
        /bin/echo -n "/Applications/Box.app"
    elif box_app_exists_in_applications_folder; then
        /bin/echo -n "$(path_to_box_app_in_applications_folder)"
    elif [ "$(number_of_box_apps_installed)" -eq 1 ]; then
        /bin/echo -n "$(path_to_first_box_app_found)"
    else
        /bin/echo -n ""
    fi
}

#
# Exit the script with a message if we're not running as root
#
function ensure_running_as_root {
    if [ $EUID -ne 0 ]; then
        echo "This script must be run as root. Please use 'sudo'."
        exit 1
    fi
}

#
# Try to unload the FUSE kext. If the unload fails, tell the user to reboot
# and exit the script.
#
function unload_kext {
    local RESULT=0
    if [[ -n "$(/usr/sbin/kextstat -l -b $KEXT_BUNDLE_IDENTIFIER)" ]]
    then
        /sbin/kextunload -b $KEXT_BUNDLE_IDENTIFIER
        RESULT=$?
    fi

    if [ $RESULT -ne 0 ]; then
      echo "Unable to unload the FUSE kext. Please reboot your machine and run this script again."
        if [ "$1" -eq 1 ]; then
          exit 2
      fi
    fi

    return $RESULT
}


#
# Disable our launchDaemon and launchAgent
#
function unload_root_au_and_helper {
    /bin/launchctl unload $AUTOUPDATER_PLIST_PATH || true

    # On older versions of Box Drive the Helper wasn't properly limited to Aqua sessions only, so also remove the "root" version too
    /bin/launchctl unload $BOX_HELPER_PLIST_PATH || true
}

#
# Remove everything installed by the umbrella pkg
#
function delete_all_the_things {
    # Remove the app
    app_path=$(box_app_path)
    rm -rf "$app_path"

    # Remove AU & other system-level components and logs.
    # If top-level "Box" folders are empty, remove them too.
    rm -rf /Library/Application\ Support/Box/Box
    if [ ! "$(ls -A /Library/Application\ Support/Box)" ]; then
        rm -rf /Library/Application\ Support/Box
    fi

    rm -rf /Library/Logs/Box/Box
    if [ ! "$(ls -A /Library/Logs/Box)" ]; then
        rm -rf /Library/Application\ Support/Box
    fi

    rm -f $AUTOUPDATER_PLIST_PATH
    rm -f $BOX_HELPER_PLIST_PATH

    # Remove any user-level components and logs.
    # If top-level "Box" folders are empty, remove them too.
    # TODO: Should we do this for every user on the machine?
    rm -rf ~/Library/Application\ Support/Box/Box
    if [ ! "$(ls -A ~/Library/Application\ Support/Box)" ]; then
        rm -rf ~/Library/Application\ Support/Box
    fi

    rm -rf ~/Library/Logs/Box/Box
    if [ ! "$(ls -A ~/Library/Logs/Box)" ]; then
        rm -rf ~/Library/Logs/Box
    fi

    # Remove FUSE
    if [ -e ~/Library/PreferencePanes/OSXFUSE.prefPane/ ]; then
        rm -rf ~/Library/PreferencePanes/OSXFUSE.prefPane/
    fi
    rm -rf /Library/Filesystems/box.fs

    # Remove Finder Extension logs
    if [ -e ~/Library/Containers/com.box.desktop.findersyncext ]; then
        rm -rf ~/Library/Containers/com.box.desktop.findersyncext
    fi
    
    # Remove Finder Extension group container
    # Note: Box Edit uses ~/Library/Group Containers/M683GB7CPW.com.box.tools
    if [ -e ~/Library/Group\ Containers/M683GB7CPW.b ]; then
        rm -rf ~/Library/Group\ Containers/M683GB7CPW.b
    fi
    
    # Remove old Finder Extension group container (was unused)
    if [ -e ~/Library/Group\ Containers/M683GB7CPW.com.box.desktop ]; then
        rm -rf ~/Library/Group\ Containers/M683GB7CPW.com.box.desktop
    fi

    # Remove WebView caches
    if [ -e ~/Library/Caches/com.box.desktop ]; then
      rm -rf ~/Library/Caches/com.box.desktop
    fi
    if [ -e ~/Library/Caches/com.box.desktop.ui ]; then
      rm -rf ~/Library/Caches/com.box.desktop.ui
    fi
    
    # Remove WebView cookies
    if [ -e ~/Library/Cookies/com.box.desktop.binarycookies ]; then
      rm -rf ~/Library/Cookies/com.box.desktop.binarycookies
    fi
}

#
# Clear out any prefs we've set
#
function clear_system_level_prefs {
    # system-level
    /usr/bin/defaults delete com.box.desktop.autoupdater || true
    /usr/bin/defaults delete com.box.desktop.installer || true
}

#
# Remove the pkg receipts
#
# Pre-1.4 releases use "com.box.installer.sync" for the main installer; 1.4 and
# later uses com.box.installer.desktop.
#
function forget_pkg_receipts {
    /usr/sbin/pkgutil --forget com.box.desktop.installer.sync
    /usr/sbin/pkgutil --forget com.box.desktop.installer.desktop
    /usr/sbin/pkgutil --forget com.box.desktop.installer.local.appsupport
    /usr/sbin/pkgutil --forget com.box.desktop.installer.autoupdater
    /usr/sbin/pkgutil --forget com.box.desktop.installer.osxfuse
}


#
# main
#

#
# The $1 command-line parameter is the fuse_failure_quits (aka -n param to the parent script)
#

fuse_failure_quits=$1

# Make sure we're clear to go
ensure_running_as_root && \
unload_kext $fuse_failure_quits && \
unload_root_au_and_helper

# perform most of the uninstall
delete_all_the_things
clear_system_level_prefs
forget_pkg_receipts

