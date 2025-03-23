#!/usr/bin/env bash

# Set up git
echo "Setting up git..."

# Set up git autocomplete
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "$HOME/.git-completion.bash"
chmod +x "$HOME/.git-completion.bash"
# Loading into shell done via bash entry config

# Set global git config
git config --global user.email "nwithan8@users.noreply.github.com"
git config --global user.name "Nate Harris"

# Set usage of SSH config by Obsidian
touch "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
