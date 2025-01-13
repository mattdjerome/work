#!/usr/local/bin/python3
'''
Check Code42 ID and basic health factors
todd@emersoncollective.com, 6/24/22
'''

# code42_health_check.py ####################################################
#
#   A script to check Code42 client health.
#
#   0.1.0   2022.06.24  Replaced previous ID script, since c42 changed file contents
#
#
################################################################################

# Notes: #######################################################################
#
# for updated 10+ client
# include client version!!!! -DONE
# log age -DONE
# refreshes every 14 minutes
#
#
#
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
                if computer_line:
                    if "SELF" in line:
                        computer_line_parts = line.split(", ")
#                         print("Computer Line:", computer_line_parts)
                        computer_line = False

                if user_line:
                    if "SELF" in line:
                        user_line_parts = line.split(", ")
#                         print("User Line", user_line_parts)
                        user_id = user_line_parts[1]
                        user_line = False

                elif "DateTime" in line:
                    raw_log_datetime = line.split("= ")[1]
                    raw_log_datetime = raw_log_datetime.split('\n')[0]
                    timenow = datetime.datetime.now()
                    log_datetime = datetime.datetime.strptime(raw_log_datetime, '%a %b %d %H:%M:%S %Z %Y')

                    time_diff = timenow - log_datetime
#                     print("Minutes old:", time_diff.seconds/60)
#                     print("Minutes old int:", int(time_diff.seconds/60))

                elif "CPVERSION" in line:
                    # CPVERSION    = 10.3.0 - 15252000061030 - Build: 81
                    version_raw = line.split("= ")[1]
                    client_version = version_raw.split(" - ")[0]
                    client_build = version_raw.split(" - ")[-1].split(": ")[1]
                    full_client_version = f"{client_version}#{client_build}".strip()
#                     print(f"Version: {full_client_version}")

                elif "USERS" in line:
                    user_line = True

                elif "COMPUTERS" in line:
                    computer_line = True

        this_id = f"{user_id} : {full_client_version} : +{int(time_diff.seconds/60)} minutes"

    except IOError:
        this_id = "app.log doesn't exist"

    print("<result>" + this_id + "</result>")


if __name__ == '__main__':
    main()