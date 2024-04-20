#!/bin/bash

SLACKDUMP_PATH="./slackdump"
SLACKDUMP2HTML_PATH="./slackdump2html.py"
DATA_DIRERCTORY="./data"

# Verify that slackdump is installed
if ! command -v $SLACKDUMP_PATH &> /dev/null
then
    echo "slackdump could not be found"
    exit
fi

# Verify that slackdump2html.py file exists
if [ ! -f $SLACKDUMP2HTML_PATH ]
then
    echo "slackdump2html.py could not be found"
    exit
fi

# Install dependencies
pip install -r requirements.txt || true

# Prepare directories
mkdir -p $DATA_DIRERCTORY || true

# Export all channels
eval $SLACKDUMP_PATH -list-channels > $DATA_DIRERCTORY/channels.txt

# Export all users
eval $SLACKDUMP_PATH -list-users > $DATA_DIRERCTORY/users.txt

# Export all emojis
eval $SLACKDUMP_PATH -emoji -base > $DATA_DIRERCTORY/emojis

# For each ID in channels.txt, dump the channel
# Skip the first line, then take the first word of each line
# This is the channel ID
for channel_id in $(tail -n +2 $DATA_DIRERCTORY/channels.txt | cut -d ' ' -f 1)
do
    eval $SLACKDUMP_PATH $channel_id
done

# Convert all slackdump files to HTML using "python slackdump2html.py"
find . -name "*.json" -exec python $SLACKDUMP2HTML_PATH {} \;
