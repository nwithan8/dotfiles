#!/usr/bin/env bash

echo "Installing Ruby..."
brew install rbenv
eval "$(rbenv init -)"
# shellcheck disable=SC2016
echo >> ~/.bashrc
echo 'eval "$(rbenv init -)"' | sudo tee -a ~/.bashrc
rbenv install "$(rbenv install -l | grep -v - | tail -1)" # Install latest version of ruby

echo "Installing Ruby utilities..."
# Bundler
gem install bundler
