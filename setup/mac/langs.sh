#!/usr/bin/env bash

# Install programming languages
echo "Installing programming languages..."

## Python
GLOBAL_PYTHON="3.10.0"
echo "Installing Python versions..."
curl https://pyenv.run | bash
eval "$(pyenv init -)"

PYTHON_VERSIONS="3 3.10 3.9 3.8 3.7" # Install latest of all listed Python versions
for V in $PYTHON_VERSIONS; do
  echo "Installing Python $V..."
  pyenv install "$V":latest
done
pyenv global "$GLOBAL_PYTHON"


## PHP
echo "Installing PHP..."
brew install php

echo "Installing PHP utilities..."
# Composer
brew install composer


## Node
echo "Installing Node.JS..."
brew install node


## Ruby
echo "Installing Ruby..."
brew install rbenv
eval "$(rbenv init -)"
# shellcheck disable=SC2016
echo 'eval "$(rbenv init -)"' | sudo tee -a ~/.bashrc
rbenv install "$(rbenv install -l | grep -v - | tail -1)" # Install latest version of ruby

echo "Installing Ruby utilities..."
# Bundler
gem install bundler


## Java
echo "Installing Java versions..."
JAVA_VERSIONS="8 11 17"
for V in $JAVA_VERSIONS; do
  echo "Installing Java $V..."
  brew install "openjdk@$V"
done

echo "Installing Java utilities..."
# Maven
brew install maven


# Go
echo "Installing Go..."
brew install go


# .NET
DOTNET_VERSIONS="Current 7.0 6.0 5.0 3.1"
echo "Installing C# and .NET..."
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
for V in $DOTNET_VERSIONS; do
  echo "Installing .NET $V..."
  ./dotnet-install.sh --channel "$V" --verbose
done
rm dotnet-install.sh
