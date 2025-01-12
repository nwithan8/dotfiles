#!/bin/sh

GPG_PRIVATE_KEY=$1

# Install git, gh and make
sudo apt-get install git gh make

# Set up GitHub authentication
echo "Starting GitHub authentication. Select 'Skip' in the next prompt and follow the instructions."
gh auth login --git-protocol ssh --web -s admin:public_key

# Add SSH key to GitHub
gh ssh-key add ~/.ssh/id_rsa.pub -t "$(hostname)"

# Add GitHub Copilot extension
gh extension install github/gh-copilot --force

# Clone the dotfiles repo
git clone git@github.com:nwithan8/dotfiles.git
cd dotfiles/setup/linux

# Run make step
make fresh-install private_key_path="$GPG_PRIVATE_KEY"
