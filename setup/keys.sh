#!/usr/bin/env bash

# Generate new RSA SSH key if it doesn't exist
if [ -f ~/.ssh/id_rsa ]; then
  echo "RSA SSH key already exists."
else
  echo "Generating new RSA key..."
  ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""
fi

# Generate new ED25519 SSH key if it doesn't exist
if [ -f ~/.ssh/id_ed25519 ]; then
  echo "ED25519 SSH key already exists."
else
  echo "Generating new ED25519 key..."
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""
fi

# Copy keys to relevant remotes for passwordless access
echo "Copying SSH keys to relevant remotes..."

# DEST example: root@192.168.1.1
while read -r DEST; do
  HOST=$(echo "$DEST" | cut -d@ -f 2)
  echo "Copying SSH key to $HOST..."
  ssh-copy-id "$DEST"
done < ../ssh_key_destinations.txt

echo "REMEMBER TO MANUALLY ADD YOUR KEYS TO GITEA!"
