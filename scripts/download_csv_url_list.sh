#!/bin/bash

# Check if the argument (filename) is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "File $1 not found!"
    exit 1
fi

# Create a file to store downloaded filenames if it doesn't exist
if [ ! -f downloaded_files.txt ]; then
    touch downloaded_files.txt
fi

# Read downloaded filenames into an array
declare -a downloaded_files
readarray -t downloaded_files < downloaded_files.txt

# Read each URL from the file and download the corresponding file
while IFS= read -r csv_urls; do
    # Split the URLs by comma
    IFS=',' read -r -a urls <<< "$csv_urls"

    # Iterate over the URLs
    for url in "${urls[@]}"; do
        # Extract filename from URL
        filename=$(basename "$url")

        # Check if the file is already downloaded
        if grep -q "^$filename$" downloaded_files.txt; then
            echo "File $filename already downloaded. Skipping..."
        else
            echo "Downloading $url..."
            wget "$url"
            echo "$filename" >> downloaded_files.txt
        fi
    done
done < "$1"

echo "Download complete!"
