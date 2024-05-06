#!/bin/bash
##################################################################
#: Date Created  : (December 30, 2014)
#: Author        : Daniel Griggs
#: Version       : 1.00
##################################################################

## How to handle input on $4
if [[ -z "$4" ]]; then
  action=0
else
  action=$4
fi

### GLOBAL VARIABLE BLOCK ###

### GLOBAL VARIABLE BLOCK ###

##
### GLOBAL FUNCTION BLOCK ###
scriptName=$( echo ${0##*\/} | cut -d. -f1 )
logIt(){
  # logger -t secureConfig "$1  ### $scriptName"
  echo  "$1  ### $scriptName"

}

verifySettings(){
  # verify that everything is on
  fwState=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | awk '{ print $3 }')
  fwStealthStatus=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode | awk '{ print $NF }')
  fwLogging=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getloggingmode | grep on)
  # Check output of above

if [[ $fwState != "enabled." ]]; then
  checkOutput=("${checkOutput[@]}" "FireWall is disabled")
  # failedChecks="$failedChecks"$'\n'"fw State - NOT SECURE"
  fi
if [[ $fwStealthStatus != "enabled" ]]; then
  checkOutput=("${checkOutput[@]}" "FireWall stealth mode disabled")
  # failedChecks="$failedChecks"$'\n'"fw Stealth Status - NOT SECURE"
  fi
if [[ ! $fwLogging =~ on ]]; then
  checkOutput=("${checkOutput[@]}" "FireWall logging disabled")
  # failedChecks="$failedChecks"$'\n'"fw Logging - NOT SECURE"
  fi
}
### GLOBAL FUNCTION BLOCK ###
##

case ${action} in

0) # verify

# just call the verify settings function.
verifySettings
if [[ ${#checkOutput[@]} -gt 0 ]]; then
  # echo for JAMF
  printf '%s\n' "<result>${checkOutput[@]}</result>"
  # write down to syslog
  for ((i = 0; i < ${#checkOutput[@]}; i++))
    do
      logIt "${checkOutput[i]}"
    done
else
  logIt "<result>Firewall enabled and configured</result>"
fi
;;
1) # secure
# echo "secure it"
logIt "Turning the Firewall on"
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
if [[ $? != 0 ]]; then
  logIt "<result>Could not enable ApplicationFirewall</result>"
  exit 1
fi

logIt "Turning stealth mode on"
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
if [[ $? != 0 ]]; then
  logIt "<result>Could not enable ApplicationFirewall stealth mode</result>"
  exit 1
fi

logIt "Enable logging on the firewall"
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
if [[ $? != 0 ]]; then
  logIt "<result>Could not enable ApplicationFirewall logging mode to on</result>"
  exit 1
fi

verifySettings
if [[ ${#checkOutput[@]} -gt 0 ]]; then
  # echo for JAMF
  printf '%s\n' "<result>${checkOutput[@]}</result>"
  # write down to syslog
  for ((i = 0; i < ${#checkOutput[@]}; i++))
    do
      logIt "${checkOutput[i]}"
    done
else
  logIt "<result>secure</result>"
fi


exit 0
;;

2) # rollBack
echo "roll it back"

/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off
if [[ $? != 0 ]]; then
  logIt "<result>Could not disable ApplicationFirewall</result>"
  exit 1
fi


/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode off
if [[ $? != 0 ]]; then
  logIt "<result>Could not disable ApplicationFirewall stealth mode</result>"
  exit 1
fi

/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode off
if [[ $? != 0 ]]; then
  logIt "<result>Could not disable ApplicationFirewall logging mode to on</result>"
  exit 1
fi

out=$(verifySettings)
if [[ ! $out =~ "NOT SECURE" ]]; then
  logIt "<result>Failed to disable security on the machine</result>"
  exit 1
fi

logIt "Disabled security FireWall content"
exit 0
;;

*)
echo "<result>test case input failed</result>"
exit 1
esac

