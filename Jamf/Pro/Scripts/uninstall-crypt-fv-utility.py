#!/usr/bin/python

# Copyright 2015 Crypt Project.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import  os,     \
        sys,     \
        plistlib,  \
        platform,   \
        subprocess
from    subprocess import Popen, \
                          PIPE,   \
                          STDOUT

##
## mech_list: A list of strings. The list of mechs to add
## index_mech: A string. The mech already in the DB, your mech_list will be installed above or below the index_mech
## index_offset: An integer. Used to position the mech_list above or below the index_mech. 0 will be directly above,
## 1 will be directly below. -1 would have one space between the mech_list and the index_mech etc...
##

##
## Currently the FV2AuthPlugin only runs at the Login Window.
## I may add support for Screen Saver unlock. There are stubs for
## the authenticate db in place because of this.
##

## Path to system.login.console.plist
system_login_console_plist = "/private/var/tmp/system.login.console.plist"

## Path to authenticate.plist
#authenticate_plist = "/private/var/tmp/authenticate.plist"

## Mechs that support FV2AuthPlugin
fv2_mechs = ["Crypt:Check,privileged","Crypt:CryptGUI","Crypt:Enablement,privileged"]
fv2_index_mech = "loginwindow:done"
fv2_index_offset = 0

def bash_command(script):
    try:
        return subprocess.check_output(script)
    except (subprocess.CalledProcessError, OSError), err:
        sys.exit("[* Error] **%s** [%s]" % (err, str(script)))

def remove_mechs_in_db(db, mech_list):
    for mech in mech_list:
        for old_mech in filter(lambda x: mech in x, db['mechanisms']):
            db['mechanisms'].remove(old_mech)
    return db

def set_mechs_in_db(db, mech_list, index_mech, index_offset):
    ## Clear away any previous configs
    db = remove_mechs_in_db(db, mech_list)

    ## Add mech_list to db
    # i = int(db['mechanisms'].index(index_mech)) + index_offset
    # for mech in mech_list:
    #     db['mechanisms'].insert(i, mech)
    #     i += 1
    return db

def edit_authdb():
    ## Export "system.login.console"
    system_login_console = bash_command(["/usr/bin/security", "authorizationdb", "read", "system.login.console"])
    f_c = open(system_login_console_plist, 'w')
    f_c.write(system_login_console)
    f_c.close()

    ## Export "authenticate"
    #authenticate = bash_command(["/usr/bin/security", "authorizationdb", "read", "authenticate"])
    #f_a = open(authenticate_plist, 'w')
    #f_a.write(authenticate)
    #f_a.close()

    ## Leave the for loop. Possible support for ScreenSaver unlock
    for p in [system_login_console_plist]:
        ## Parse the plist
        d = plistlib.readPlist(p)

        ## Add FV2 mechs
        d = set_mechs_in_db(d, fv2_mechs, fv2_index_mech, fv2_index_offset)

        ## Write out the changes
        plistlib.writePlist(d, p)

    f_c = open(system_login_console_plist, "r")
    p = Popen(["/usr/bin/security", "authorizationdb", "write", "system.login.console"], stdout=PIPE, stdin=PIPE, stderr=PIPE)
    stdout_data = p.communicate(input=f_c.read())
    f_c.close()

    #f_a = open(authenticate_plist, "r")
    #p = Popen(["/usr/bin/security", "authorizationdb", "write", "authenticate"], stdout=PIPE, stdin=PIPE, stderr=PIPE)
    #stdout_data = p.communicate(input=f_a.read())
    #f_a.close()

def check_root():
    if not os.geteuid() == 0:
        sys.exit("\nOnly root can run this script\n")

def check_os():
    OSVersion, _, _ = platform.mac_ver()
    OSVersion = int(OSVersion.split('.')[1])
    if OSVersion < 9:
        sys.exit("\nOnly OS X 10.9 and above can run this script\n")

def main(argv):
    check_root()
    check_os()
    edit_authdb()

if __name__ == '__main__':
    main(sys.argv)

