#!/usr/bin/env bash

# Install Microsoft IDEs

# Update brew casks
brew tap homebrew/cask-versions

# Install Visual Studio Code
echo "Installing Visual Studio Code..."
brew install --cask visual-studio-code

# Install Visual Studio
echo "Installing Visual Studio..."
brew install --cask visual-studio
