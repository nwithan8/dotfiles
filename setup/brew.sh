#!/usr/bin/env bash

# ONLY RUN FROM MAKE

## Install brew
echo "Installing brew package manager..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

KERNEL=`uname -s`
if [ $KERNEL == 'Darwin' ]
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ $KERNEL == 'Linux' ]
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

## Install third-party taps
# shellcheck disable=SC2162
while read -r TAP; do
  echo "Adding $TAP tap..."
  brew tap "$TAP"
done < ../brew_taps.txt

## Install packages
while read -r PACKAGE; do
  echo "Installing $PACKAGE package via brew..."
  brew install "$PACKAGE"
done < ../brew_packages.txt

## Install casks
while read -r CASK; do
  echo "Installing $CASK cask via brew..."
  brew install --cask "$CASK"
done < ../brew_casks.txt

# Backup brew packages
alchemist --backup

# Set up necessary directories
mkdir ~/.nvm || true # nvm
