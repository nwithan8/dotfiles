#!/bin/bash

# Decrypt the private files.

# Check if GPG is installed.
if ! [ -x "$(command -v gpg)" ]; then
  echo "Error: GPG is not installed."
  exit 1
fi

# Collect parameters.
root_directory="$1"

# Set up constants
ENCRYPTED_SUFFIX=".enc"
ENCRYPTED_FOLDER_DIRECTORY="$root_directory/dot/encrypted"
DECRYPT_SCRIPT="$root_directory/scripts/security/decrypt_with_gpg.sh"

# For each file in the encrypted folder and its sub-folders
find "$ENCRYPTED_FOLDER_DIRECTORY" -type f | while read -r path; do
  # target file is path with encrypted suffix removed
  target_file="${path%$ENCRYPTED_SUFFIX}"
  # target path is path with "encrypted" replaced with "decrypted"
  target_path="${target_file/encrypted/decrypted}"
  "$DECRYPT_SCRIPT" "$path" "$target_path"
done
