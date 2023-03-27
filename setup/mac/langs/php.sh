#!/usr/bin/env bash

PHP_VERSIONS="7.4 8.0 8.1 8.2" # Install latest of all listed PHP versions
for V in $PHP_VERSIONS; do
  echo "Installing PHP $V..."
  brew install shivammathur/php/php@"$V"
done

echo "Installing PHP utilities..."
# Composer
brew install composer
