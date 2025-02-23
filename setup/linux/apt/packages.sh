#!/usr/bin/env bash

# ONLY RUN VIA MAKE

## Install packages
while read -r PACKAGE; do
  echo "Installing $PACKAGE package via apt-get..."
  apt-get install "$PACKAGE" -y
done < apt/packages.txt
