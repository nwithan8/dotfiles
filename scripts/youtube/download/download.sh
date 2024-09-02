#!/bin/sh

# Read each line in the config file
# Each line has the following format:
# <FOLDER NAME>;<CHANNEL_OR_PLAYLIST_URL>;<FILE_NAME_TEMPLATE>
while IFS=';' read -r folder url template; do
  # Create the folder if it doesn't exist
  mkdir -p "$folder"
  # Download the videos
  yt-dlp -o "$folder/$template" "$url" --restrict-filenames --download-archive "archive.txt"
done < download_list.txt
