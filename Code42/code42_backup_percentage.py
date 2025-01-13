#!/usr/bin/env python3

test_str = 'complete'
# string to search in file
with open(r'/Library/Logs/Crashplan/app.log', 'r') as file:
    lines = file.readlines()
    for row in lines:
        if test_str in row:
            percent_raw = row.split(":")[1]
            backup_percent = percent_raw.split("%")[0]
            backup_number_float = float(backup_percent)
            percent_complete = round(backup_number_float,2)
            print(f"<result>{percent_complete}</result>")
