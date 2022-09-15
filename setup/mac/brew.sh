#!/usr/bin/env bash

## Install brew
echo "Installing brew package manager..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install first-party packages
PACKAGES="git gh rsync tree"
for P in $PACKAGES; do
  echo "Installing $P via brew..."
  brew install "$P"
done

## Install second-party packages
PACKAGES="iterm2 powershell"
for P in $PACKAGES; do
  echo "Installing $P via brew..."
  brew install --cask "$P"
done

## Install third-party packages
# Justin Hammond
brew tap justintime50/formulas
PACKAGES="alchemist clienv"
for P in $PACKAGES; do
  echo "Installing $P via brew..."
  brew install "$P"
done


# Backup brew packages
alchemist --backup
