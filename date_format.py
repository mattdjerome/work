#!/usr/bin/env python3

from datetime import datetime

# Get the current date
current_date = datetime.now()

# Format the date as year-month-day
formatted_date = current_date.strftime('%Y-%m-%d')

# Print the formatted date
print(formatted_date)