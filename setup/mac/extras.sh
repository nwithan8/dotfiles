#!/usr/bin/env bash

# Extra, optional enhancements

# Use bat rather than cat
echo "Downloading improved cat command"
brew install bat
echo 'alias cat="bat"' | sudo tee -a ~/.bashrc

# Set up key bindings to use fzf for history search
echo "Setting up key bindings for fzf"
"$(brew --prefix)"/opt/fzf/install
source "$HOME/.bashrc"
