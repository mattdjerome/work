#!/usr/local/ec/bin/python3



#         Name:  safari_extensions.py
#         Description:  This extension attribute returns a list of the names and
#              versions of all Safari add-ons installed for the current
#              user. Inspired by the managed_python3 version of Chrome Extensions script by Elliot Jordan <elliot@lindegroup.com>
#         Author:  Daniel Mortensen <dmortensen@simonsfoundation.org>
#         Created:  2022-10-28
#         Last Modified:  2022-10-28
#         Version:  1.0

import os
import xml.etree.ElementTree as ET
import re
import sys
from SystemConfiguration import SCDynamicStoreCopyConsoleUser

def get_current_user():
		username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0] 
		return username
def get_extensions(username):
		extensions_list = ("/Users/%s/Library/Containers/com.apple.Safari/"
			"Data/Library/Safari/AppExtensions/Extensions.plist" % username)
		return extensions_list

def print_results(extensions_list):
    tree = ET.parse(extensions_list)
    root = tree.getroot()
    list = ""
    for key in root.iter('key'):
        match = re.search('com.',key.text)
        if match:
            result = key.text
            list = list + result + "\n"
    return list.strip()

def main():
		username = get_current_user()
		extensions_list = get_extensions(username)
		#results = parse_results(manifest_list)
		to_echo = print_results(extensions_list)
		print("<result>%s</result>" % to_echo)
	
if __name__ == '__main__':
		main()