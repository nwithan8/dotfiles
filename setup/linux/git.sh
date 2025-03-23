#!/usr/bin/env bash

# Set up git
echo "Setting up git..."

# Set up git autocomplete
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
chmod +x ~/.git-completion.bash
# Loading into shell done via bash entry config

# Set global git config
git config --global user.email "nwithan8@users.noreply.github.com"
git config --global user.name "Nate Harris"

# Need to indicate default store for Linux
# ref: https://github.com/git-ecosystem/git-credential-manager/blob/release/docs/credstores.md
git config --global credential.credentialStore gpg

# Set usage of SSH config by Obsidian
chmod 600 ~/.ssh/config


