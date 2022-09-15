#!/usr/bin/env bash

# Install JetBrains IDEs

# Update brew casks
brew tap homebrew/cask-versions

# Install toolbox
echo "Installing JetBrains Toolbox..."
brew install --cask jetbrains-toolbox

# Install IntelliJ
echo "Installing IntelliJ..."
brew install --cask intellij-idea

# Install Rider
echo "Installing Rider..."
brew install --cask rider

# Install PyCharm
echo "Installing PyCharm..."
brew install --cask pycharm

# Install WebStorm
echo "Installing WebStorm..."
brew install --cask webstorm

# Install PhpStorm
echo "Installing PhpStorm..."
brew install --cask phpstorm

# Install GoLand
echo "Installing GoLang..."
brew install --cask goland

# Install RubyMine
echo "Installing RubyMine..."
brew install --cask rubymine
