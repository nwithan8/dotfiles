#!/usr/bin/env bash

REPO_LOCATION=$1
DOT_FOLDER="$REPO_LOCATION/dot"
DECRYPTED_FOLDER="$DOT_FOLDER/decrypted"
OPEN_FOLDER="$DOT_FOLDER/open"

# Symlink files to their appropriate locations
# Using symlinks instead of copying files allows for updates to this repo to be reflected on the user's system immediately

# Link bash-ftw profiles
echo "Installing bash-ftw profiles..."
# for each directory in DECRYPTED_FOLDER, find all files starting with .bashrc and symlink them to the same name in ~
for dir in "$DECRYPTED_FOLDER"/*; do
    if [ -d "$dir" ]; then
        for file in "$dir"/.bashrc*; do
            FILE_NAME=$(basename "$file")
            DEST_FILE="$HOME/$FILE_NAME"
            echo "Symlinking $file to $DEST_FILE"
            ln -s "$file" "$DEST_FILE" || true
        done
    fi
done
# for each file in OPEN_FOLDER, symlink it to the same name in ~
for dir in "$OPEN_FOLDER"/*; do
    if [ -d "$dir" ]; then
        for file in "$dir"/.bashrc*; do
            FILE_NAME=$(basename "$file")
            DEST_FILE="$HOME/$FILE_NAME"
            echo "Symlinking $file to $DEST_FILE"
            ln -s "$file" "$DEST_FILE" || true
        done
    fi
done

# Install crontab
# shellcheck disable=SC2016
CRONTAB_FILE="$OPEN_FOLDER/crontab"
echo "Installing crontab from $CRONTAB_FILE"
crontab "$CRONTAB_FILE"

# Link rclone config
RCLONE_CONFIG_DIR="$HOME/.config/rclone"
mkdir -p "$RCLONE_CONFIG_DIR" || true
RCLONE_CONFIG_FILE="$DECRYPTED_FOLDER/rclone.conf"
echo "Installing rclone config from $RCLONE_CONFIG_FILE"
# Backup existing config file(s) if they exists
if [ -f "$RCLONE_CONFIG_DIR/rclone.conf" ] || [ -f "$RCLONE_CONFIG_DIR/.rclone.conf" ]; then
    mv "$RCLONE_CONFIG_DIR/rclone.conf" "$RCLONE_CONFIG_DIR/rclone.conf.old" || true
    mv "$RCLONE_CONFIG_DIR/.rclone.conf" "$RCLONE_CONFIG_DIR/.rclone.conf.old" || true
fi
ln -s "$RCLONE_CONFIG_FILE" "$RCLONE_CONFIG_DIR/rclone.conf" || true
ln -s "$RCLONE_CONFIG_FILE" "$RCLONE_CONFIG_DIR/.rclone.conf" || true # Some versions of rclone use .rclone.conf instead of rclone.conf


# Link scripts
SCRIPTS_DIR="$HOME/.scripts"
mkdir -p "$SCRIPTS_DIR" || true
echo "Installing scripts to $SCRIPTS_DIR"
ln -s "$REPO_LOCATION/scripts/bitwarden/bw_add_sshkeys.py" "$SCRIPTS_DIR/bw_add_sshkeys.py" || true
ln -s "$REPO_LOCATION/scripts/ntfy/ntfy_send.sh" "$SCRIPTS_DIR/ntfy_send.sh" || true
