#!/bin/sh

# This script updates the Radicale calendars by uploading/overwriting ICS files
# to the Radicale server. It is intended to be run as a cron job.

# Configuration

# An array of calendar_name,ics_file_path pairs
# Add to array
ICS_LIST="first,https://link.com/calendar.ics"

ICS_LIST="${ICS_LIST} second,https://link.com/calendar2.ics"

ICS_LIST="${ICS_LIST} third,https://link.com/calendar3.ics"

# Radicale settings
R_URL=""
R_USER=""
R_PASSWORD=""


# Loop through each ICS list pair
for ics_info in $ICS_LIST; do
    # Each line is CALENDAR_NAME,ICS_FILE_PATH
    calendar_name=${ics_info%%,*}
    ics_file=${ics_info#*,}

    # Download the ICS file to a temp file
    temp_file=$(mktemp)
    curl -s -o "$temp_file" "$ics_file"

    # Upload the ICS file to the Radicale server
    echo "Uploading $calendar_name ($ics_file) to Radicale server..."
    curl -u "$R_USER:$R_PASSWORD" -X PUT "$R_URL/$R_USER/$calendar_name" --data-binary "@$temp_file"

    # Clean up the temp file
    rm "$temp_file"
done
