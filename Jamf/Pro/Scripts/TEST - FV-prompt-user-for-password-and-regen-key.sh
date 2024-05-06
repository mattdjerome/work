#!/bin/bash

GUI_USER=$(who | grep console | grep -v '_mbsetupuser' | awk '{print $1}') 
killall Pashua

setup_pashua_prompt_prefs(){
conf="# Window
*.title = Password Required
*.floating = 1
# Message
msg.type = text
msg.text = Filevault is attempting to repair your recovery key [return][return]Enter your password to allow this.
msg.x = 75
msg.y = 100
# Password label
pwl.type = text
pwl.text = Password:
pwl.x = 75
pwl.y = 65
# Password field
psw.type = password
psw.mandatory = 1
psw.width = 250
psw.x = 145
psw.y = 60
# Default button
db.type = defaultbutton
db.label = Allow
# Cancel button
# cb.type = cancelbutton
# cb.label = Cancel
img.type = image
img.maxwidth = 65
img.y = 100
img.x = 0
img.path = /System/Library/PreferencePanes/Security.prefPane/Contents/Resources/FileVault.icns"
# Write config file
pashua_configfile=$(/usr/bin/mktemp /tmp/pashua_XXXXXXXXX)
echo "$conf" > "$pashua_configfile"
}

check_provided_password(){
 echo "hi"
}

checkGuiUserInFV(){
  ## check to make sure the GUI user has the ability to
  ## add users to filevault before prompting for the password
  if [[ -z $(fdesetup list | grep "$guiUser") ]]; then
    echo "GUI user is not in filevault, exiting"
    jamf recon
    exit 1
  else
    echo "GUI user found in FV, continuing"
  fi
}

rotate_fv_keys(){

expect -c "
log_user 0
spawn fdesetup changerecovery -personal
expect \"Enter the user name:\"
send ${GUI_USER}\r
expect \"Enter the password for the user '${GUI_USER}':\"
send ${userPassword}\r
log_user 1
expect eof
"
}


main(){
setup_pashua_prompt_prefs

# Keep prompting until we get a real password
countOfTries=0
until dscl /Search -authonly "$GUI_USER" "$userPassword" &>/dev/null; do
  (( countOfTries++ ))
  local rawResult=$("/Applications/Pashua.app/Contents/MacOS/Pashua" "$pashua_configfile")
  local userPassword=$(echo "$rawResult" | grep psw | cut -d'=' -f2-)
  if (( countOfTries >=3 )); then
    exit 1
  fi
done

rotate_fv_keys
# # Remove config file
# rm "$pashua_configfile"

unset rawResult
unset userPassword
}

main $@

