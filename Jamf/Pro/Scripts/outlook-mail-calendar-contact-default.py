#!/usr/bin/python


# https://www.jamf.com/jamf-nation/discussions/29313/using-outlook-instead-of-mail-app-in-this-terminal-command#responseChild172243
from LaunchServices import *

LSSetDefaultHandlerForURLScheme("mailto", "com.microsoft.outlook")
LSSetDefaultHandlerForURLScheme("com.apple.mail.email", "com.microsoft.outlook")
LSSetDefaultRoleHandlerForContentType("com.apple.ical.ics", kLSRolesAll, "com.microsoft.Outlook")
LSSetDefaultRoleHandlerForContentType("com.apple.ical.vcs", kLSRolesAll, "com.microsoft.Outlook")
LSSetDefaultRoleHandlerForContentType("webcal", kLSRolesAll, "com.microsoft.Outlook")

LSSetDefaultRoleHandlerForContentType("public.vcard", kLSRolesAll, "com.microsoft.Outloook")

