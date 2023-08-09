#!/usr/bin/env bash

REPO_LOCATION=$1

# Symlink files to their appropriate locations
# Using symlinks instead of copying files allows for updates to this repo to be reflected on the user's system immediately

# BashFTW profiles
DOT_FOLDER="$REPO_LOCATION/dot"
# for each directory in DOT_FOLDER, find all files starting with .bashrc and symlink them to the same name in ~
for dir in "$DOT_FOLDER"/*; do
    if [ -d "$dir" ]; then
        for file in "$dir"/.bashrc*; do
            FILE_NAME=$(basename "$file")
            DEST_FILE="$HOME/$FILE_NAME"
            echo "Symlinking $file to $DEST_FILE"
            ln -s "$file" "$DEST_FILE" || true
        done
    fi
done

# Scripts
SCRIPTS_DIR="$HOME/.scripts"
mkdir -p "$SCRIPTS_DIR" || true
ln -s "$REPO_LOCATION/scripts/bitwarden/bw_add_sshkeys.py" "$SCRIPTS_DIR/bw_add_sshkeys.py" || true
