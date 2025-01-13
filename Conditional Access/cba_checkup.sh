#!/bin/bash

current_user=$(ls -l /dev/console | awk '{print $3}')
uid=$(id -u $current_user)
final_result='Unknown error. '
cert_file='/tmp/okta_cba_cert.txt'
#echo ("<result>start</result>")
#cert_exp_raw=$(security find-certificate -c /Users/mjerome/Library/Keychains/okta.keychain-db -p)
cert_exp_raw=$(launchctl asuser $uid sudo -iu $username security find-certificate -c 'Okta MTLS' -p)
echo $cert_exp_raw