#!/bin/zsh

# Path to the log file
log_file="/Library/Logs/JamfConnect/UserElevationReasons.log"

# Check if the log file exists
if [ ! -f "$log_file" ]; then
    # If the log file doesn't exist, output a specific message for the extension attribute
    echo "<result>No Jamf Connect privilege elevations</result>"
    exit 0
fi

# Get the most recent 3 entries from the log file
latest_log_entries=$(tail -n 30 "$log_file")

# Begin the result string
recent_times="<result>"

# Process each log entry
while IFS= read -r log_entry; do
    # Remove the specific text from the log entry
    cleaned_entry=$(echo "$log_entry" | sed 's/elevated to admin for stated reason//g')

    # Extract the date/time from the cleaned log entry
    gmt_date=$(echo "$cleaned_entry" | awk '{print $1, $2}')
    
    # Convert GMT to Eastern Time
    eastern_date=$(date -j -f "%Y-%m-%d %H:%M:%S" "$gmt_date" -v-5H "+%Y-%m-%d %H:%M:%S")
    
    # Check if Daylight Saving Time is in effect
    daylight_saving=$(date -j -f "%Y-%m-%d %H:%M:%S" "$gmt_date" "+%Z")
    
    if [ "$daylight_saving" = "EDT" ]; then
        eastern_date=$(date -j -f "%Y-%m-%d %H:%M:%S" "$gmt_date" -v-4H "+%Y-%m-%d %H:%M:%S")
    fi
    
    # Extract the user information from the cleaned log entry
    user_info=$(echo "$cleaned_entry" | cut -d ' ' -f4-)
    
    # Append the date/time and user information to the result string
    recent_times+="$eastern_date $user_info\n"
done <<< "$latest_log_entries"

# End the result string
recent_times+="</result>"

# Output for Jamf Pro extension attribute
echo -e "$recent_times"
