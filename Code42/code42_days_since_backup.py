#!/usr/local/ec/bin/python3
'''
Checks days since last contacted Code42
Modidifed from todd@emersoncollective code42 health check



'''

# code42_last_activity_date.py ####################################################
#
#   A script to check Code42 last server contact.
#
################################################################################

# TTD: #########################################################################
#
#
#
################################################################################

import datetime


def main():
    id_file = "/Library/Logs/CrashPlan/app.log"
    this_id = "Undefined"
    computer_line = False
    user_line = False
    try:
        with open(id_file, encoding='utf-8') as id_input_file:
            id_lines = id_input_file.readlines()
            for line in id_lines:
                if "DateTime" in line:
                    raw_log_datetime = line.split("= ")[1]
                    raw_log_datetime = raw_log_datetime.split('\n')[0]
                    timenow = datetime.datetime.now()
                    log_datetime = datetime.datetime.strptime(raw_log_datetime, '%a %b %d %H:%M:%S %Z %Y')

                    time_diff = timenow - log_datetime
                    days_old = int(time_diff.seconds/86400)
  

    except IOError:
        days_old = "app.log doesn't exist"

    except Exception as exception_message:
        days_old = exception_message

    print(f"<result>{days_old}</result>")


if __name__ == '__main__':
    main()
