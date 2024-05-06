#!/bin/sh
###################################################################
# A script to collect the Version of Canon UFR II Printer Driver. #
###################################################################

PLIST="/Library/Printers/Canon/CUPS_Printer/Utilities/Canon Office Printer Utility.app/Contents/Info.plist"
KEY="CFBundleShortVersionString"

if [ -f "${PLIST}" ]; then
    RESULT=$(/usr/bin/defaults read "${PLIST}" "${KEY}" 2>/dev/null)
fi

/bin/echo "<result>${RESULT}</result>"

exit 0
