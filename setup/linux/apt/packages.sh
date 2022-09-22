#!/usr/bin/env bash

## Install packages
while read -r PACKAGE; do
  echo "Installing $PACKAGE package via apt-get..."
  apt-get install "$PACKAGE"
done < packages.txt
