#!/bin/bash

# Encrypt the private files.

# Check if GPG is installed.
if ! [ -x "$(command -v gpg)" ]; then
  echo "Error: GPG is not installed."
  exit 1
fi

# Collect parameters.
root_directory="$1"

# Set up constants
ENCRYPTED_SUFFIX=".enc"
DECRYPTED_FOLDER_DIRECTORY="$root_directory/dot/decrypted"
ENCRYPT_SCRIPT="$root_directory/scripts/security/encrypt_with_gpg.sh"
SELF="n8gr8gbln@gmail.com"

# For each file in the decrypted folder and its sub-folders
find "$DECRYPTED_FOLDER_DIRECTORY" -type f | while read -r path; do
  # target file is path with encrypted suffix added
  target_file="$path$ENCRYPTED_SUFFIX"
  # target path is path with "decrypted" replaced with "encrypted"
  target_path="${target_file/decrypted/encrypted}"
  "$ENCRYPT_SCRIPT" "$path" "$SELF" "$target_path"
done
