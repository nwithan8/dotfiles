#!/bin/bash

# Decrypts a file with GPG with a private key.

# Usage: decrypt_with_gpg.sh <file> [<output>]

# Example: decrypt_with_gpg.sh ~/Documents/secret.txt.enc ~/Documents/secret.txt

# Dependencies: gpg

# Check if a file was specified.
if [ $# -lt 1 ]; then
  echo "Usage: decrypt_with_gpg.sh <file> [<output>]"
  exit 1
fi

# Check if GPG is installed.
if ! [ -x "$(command -v gpg)" ]; then
  echo "Error: GPG is not installed."
  exit 1
fi

# Collect parameters.
file="$1"

# Set up constants
ENCRYPTED_SUFFIX=".enc"

# Prepare output file name (remove the suffix)
# Use output file name if specified.
if [ $# -eq 2 ]; then
  output_file="$2"
else
  output_file="${file%$ENCRYPTED_SUFFIX}"
fi

# Check if the file exists.
if ! [ -f "$file" ]; then
  echo "Error: $file does not exist."
  exit 1
fi

# Decrypt the file.
gpg --output "$output_file" --decrypt "$file"
