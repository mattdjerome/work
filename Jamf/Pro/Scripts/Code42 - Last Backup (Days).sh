#!/usr/local/bin/python3

# Notes ########################################################################
#
#	returns "Never backed up" if greater than 10 years
#
#	returns days since last back up, otherwise
#
################################################################################

from __future__ import print_function
import datetime

def main():
	cp42_log = '/Library/Logs/CrashPlan/history.log.0'

	# read the log
	with open(cp42_log) as f:
		content = f.read().splitlines()

	# find date of most recent complete backup, convert to date
	recent_full_date = datetime.datetime(1900, 1, 1)
	for item in reversed(content):
		if 'Completed backup' in item:
			recent_full = item.split('[')[0][2:]
			recent_full = recent_full.rstrip()
			recent_full_date = datetime.datetime.strptime(recent_full, "%m/%d/%y %I:%M%p")
			break

	# find days since last full backup
	time_since = int((datetime.datetime.today() - recent_full_date).total_seconds()/86400)

	if time_since > 3650:
		print("<result>9999</result>")
	else:
		# return days
		print("<result>" + str(time_since) + "</result>")

if __name__ == '__main__':
    main()
