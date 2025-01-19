#!/usr/bin/env bash

# Set up GitHub authentication
echo "Starting GitHub authentication. Select 'Skip' in the next prompt and follow the instructions."
gh auth login --git-protocol ssh --web -s admin:public_key || true  # Could already be logged in

# Add SSH key to GitHub
gh ssh-key add ~/.ssh/id_rsa.pub -t "$(hostname)" || true  # Could already exist

# Add GitHub Copilot extension
gh extension install github/gh-copilot --force
