#!/bin/bash

# Encrypts a file with GPG using a recipient's email address.

# Usage: encrypt_with_gpg.sh <file> <recipient> [<output>]

# Example: encrypt_with_gpg.sh ~/Documents/secret.txt me@example.com ~/Documents/secrets.enc

# Dependencies: gpg

# Check if a file and recipient were specified.
if [ $# -lt 2 ]; then
  echo "Usage: encrypt_with_gpg.sh <file> <recipient> [<output>]"
  exit 1
fi

# Check if GPG is installed.
if ! [ -x "$(command -v gpg)" ]; then
  echo "Error: GPG is not installed."
  exit 1
fi

# Collect parameters.
file="$1"
recipient="$2"

# Set up constants
ENCRYPTED_SUFFIX=".enc"

# Prepare output file name (add the suffix)
if [ $# -eq 3 ]; then
  output_file="$3"
else
  output_file="$file$ENCRYPTED_SUFFIX"
fi

# Check if the file exists.
if ! [ -f "$file" ]; then
  echo "Error: $file does not exist."
  exit 1
fi

# Make the output directory if it doesn't exist.
mkdir -p "$(dirname "$output_file")"

# Encrypt the file
gpg --recipient "$recipient" --output "$output_file" --encrypt "$file"
