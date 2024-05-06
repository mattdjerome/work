#!/bin/bash

authInfo=api_user:pPxoziH59Y2j1DASIoa0n1
jamfURL="https://wjec-2a.cmdsec.com/JSSResource"
getInXML=("-H" "accept: text/xml")
sendInXML=("-H" "content-type: text/xml")
makeItPretty="xmllint --format -"


computerSerial=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}')
# computerSerial="C02VJ2GAHV2Q"
# echo $computerSerial

computerInventoryRecord=$(curl -sku $authInfo "${getInXML[@]}" "$jamfURL/computers/serialnumber/$computerSerial")
# echo $computerInventoryRecord
# /usr/bin/curl -sku $authInfo "-H" "content-type: text/xml" "https://wjec-2a.cmdsec.com:8443/JSSResource/computers/serialnumber/C02VJ2GAHV2Q"

computerSiteMembership=$(echo $computerInventoryRecord | xmllint --xpath '/computer/general/site/name/text()' -)
# echo $computerSiteMembership

defaults write /Library/Preferences/com.emersoncollective.jamf_info.plist siteMembership -string "$computerSiteMembership"





