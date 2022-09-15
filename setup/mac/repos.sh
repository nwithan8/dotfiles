#!/usr/bin/env bash

# Make code folder
echo "Setting up code folder..."
mkdir -p ~/code/

# Clone repositories
echo "Cloning GitHub repositories using SSH..."

while read -r REPO; do
  REPO_NAME=$(echo "$REPO" | cut -d/ -f 2)
  echo "Cloning $REPO from GitHub..."
  git clone git@github.com:"$REPO".git ~/code/"$REPO_NAME"
done < github_repo_list.txt
