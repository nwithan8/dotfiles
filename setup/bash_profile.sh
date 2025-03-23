#!/usr/bin/env bash

REPO_LOCATION=$1

DOT_FOLDER="$REPO_LOCATION/dot"
OPEN_FOLDER="$DOT_FOLDER/open"
ENTRY_FOLDER="$OPEN_FOLDER/entry"
BIN_FOLDER="$HOME/.bin"

do_remove_symlink() {
  DEST_FILE=$1

  # Remove symlink if it exists
  if [ -L "$DEST_FILE" ]; then
    echo "Removing symlink $DEST_FILE"
    rm "$DEST_FILE" || true
  fi
}

do_symlink_file() {
  SRC_FILE=$1
  DEST_FILE=$2

  # Verify SRC_FILE exists, skip if it doesn't
  if [ ! -f "$SRC_FILE" ]; then
    echo "Error: $SRC_FILE does not exist"
    return 1
  fi

  DEST_FOLDER=$(dirname "$DEST_FILE")
  mkdir -p "$DEST_FOLDER" || true

  # Remove symlink if it exists
  do_remove_symlink "$DEST_FILE"

  # Symlink file
  echo "Symlinking $SRC_FILE to $DEST_FILE"
  ln -s "$SRC_FILE" "$DEST_FILE" || true
}

do_symlink_folder_files_matching_pattern() {
  SRC_FOLDER=$1
  DEST_FOLDER=$2
  PATTERN=$3

  # Symlink files in folder
  for file in "$SRC_FOLDER"/$PATTERN; do
    FILE_NAME=$(basename "$file")
    DEST_FILE="$DEST_FOLDER/$FILE_NAME"
    do_symlink_file "$file" "$DEST_FILE"
  done
}

do_symlink_folder_files() {
  do_symlink_folder_files_matching_pattern "$1" "$2" "*"
}

# Make necessary directories
mkdir -p "$BIN_FOLDER"

# Need to copy the ._bashrc.entry files, ssh-*-init files and the default entrypoints
rm "$HOME"/.bash_profile && do_symlink_file "$OPEN_FOLDER"/.bash_profile "$HOME"/.bash_profile
rm "$HOME"/.bashrc && do_symlink_file "$OPEN_FOLDER"/.bashrc "$HOME"/.bashrc
do_symlink_file "$OPEN_FOLDER"/ssh-agent-init "$BIN_FOLDER"/ssh-agent-init
do_symlink_file "$OPEN_FOLDER"/ssh-keychain-init "$BIN_FOLDER"/ssh-keychain-init
do_symlink_file "$ENTRY_FOLDER"/._bashrc.entry "$HOME"/._bashrc.entry
do_symlink_file "$ENTRY_FOLDER"/._bashrc.entry.linux "$HOME"/._bashrc.entry.linux
do_symlink_file "$ENTRY_FOLDER"/._bashrc.entry.mac "$HOME"/._bashrc.entry.mac


# Reload shell to load bash-ftw
# shellcheck disable=SC1090
source "$HOME"/.bashrc

