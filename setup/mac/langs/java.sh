#!/usr/bin/env bash

echo "Installing Java versions..."
JAVA_VERSIONS="8 11 17"
for V in $JAVA_VERSIONS; do
  echo "Installing Java $V..."
  brew install "openjdk@$V"
done

echo "Installing Java utilities..."
# Maven
brew install maven
