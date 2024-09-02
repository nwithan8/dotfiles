#!/bin/sh

# Read each line in the config file
# Each line has the following format:
# <FOLDER NAME>;<CHANNEL_OR_PLAYLIST_URL>;<OPTIONAL_FILTERS>;<FILE_NAME_TEMPLATE>
while IFS=';' read -r folder url filters template; do
  # If line begins with #, skip it
  # shellcheck disable=SC3057
  if [ "${folder:0:1}" = "#" ]; then
    continue
  fi
  # Create the folder if it doesn't exist
  mkdir -p "$folder"
  # Prep command
  PRE_FLAGS="-o \"$folder\"/\"$template\""
  if [ -n "$filters" ]; then
    PRE_FLAGS="$PRE_FLAGS --match-filter \"$filters\""
  fi
  POST_FLAGS="--write-auto-subs --write-subs --sub-lang en --convert-subs srt --restrict-filenames --download-archive \"archive.txt\""
  # Download the videos
  # shellcheck disable=SC2086
  COMMAND="yt-dlp $PRE_FLAGS \"$url\" $POST_FLAGS"
  echo $COMMAND
  eval $COMMAND
done < download_list.txt
