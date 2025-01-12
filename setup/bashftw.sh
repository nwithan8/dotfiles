#!/usr/bin/env bash

# Need to navigate to home directory
cd ~

# Set up .bashrc (needed to install bash-ftw correctly)
touch ~/.bashrc

# Download and install bash-ftw
echo "Downloading bash-ftw from GitHub..."
git clone https://github.com/jontsai/bash-ftw.git ~/bash-ftw

echo "Installing bash-ftw..."
~/bash-ftw/install.sh

# Copy source command into /etc/profile
# shellcheck disable=SC2016
echo '[[ -s "$HOME/.bashrc" ]] && source $HOME/.bashrc' | sudo tee -a /etc/profile

# Set up personal bash-ftw profile
touch ~/.bashrc."$(whoami)"

# Reload shell to load bash-ftw
# shellcheck disable=SC1090
source ~/.bashrc
