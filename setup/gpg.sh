#!/bin/bash

# Import private key to GPG.

# Check if GPG is installed.
if ! [ -x "$(command -v gpg)" ]; then
  echo "Error: GPG is not installed."
  exit 1
fi

# Collect parameters.
private_key_file="$1"

# Import the private key.
gpg --import "$private_key_file"
