#!/usr/bin/env bash

# Extra, optional enhancements

# Use bat rather than cat
echo "Downloading improved cat command"
brew install bat
echo 'alias cat="bat"' | sudo tee -a ~/.bashrc

