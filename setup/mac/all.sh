#!/usr/bin/env bash

# Run post-shell change

# Create SSH key
sh ./keys.sh

# Install brew
sh ./brew.sh

# Install bash-ftw
sh ./bashftw.sh

# Set up git
sh ./git.sh

# Set up GitHub
sh ./github.sh

# Install git repos
sh ./repos.sh

# Install programming languages
sh ./langs.sh

# Install IDEs
sh ./ides.sh

