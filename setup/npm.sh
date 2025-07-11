#!/usr/bin/env bash

# ONLY RUN FROM MAKE

## Install packages
while read -r PACKAGE; do
  echo "Installing $PACKAGE package via npm..."
  npm install -g "$PACKAGE"
done < ../npm_packages.txt
