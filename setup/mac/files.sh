#!/usr/bin/env bash

REPO_LOCATION=$1

# Symlink files to their appropriate locations
# Using symlinks instead of copying files allows for updates to this repo to be reflected on the user's system immediately

# BashFTW profiles
ln -s "$REPO_LOCATION/dot/.bashrc.nharris" ~/.bashrc.nharris || true
ln -s "$REPO_LOCATION/dot/.bashrc.nharris.mac" ~/.bashrc.nharris.mac || true

# Scripts
SCRIPTS_DIR="$HOME/.scripts"
mkdir -p "$SCRIPTS_DIR" || true
ln -s "$REPO_LOCATION/scripts/bitwarden/bw_add_sshkeys.py" "$SCRIPTS_DIR/bw_add_sshkeys.py" || true
