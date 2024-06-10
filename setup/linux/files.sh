#!/usr/bin/env bash

REPO_LOCATION=$1

DOT_FOLDER="$REPO_LOCATION/dot"
DECRYPTED_FOLDER="$DOT_FOLDER/decrypted"
OPEN_FOLDER="$DOT_FOLDER/open"

# Symlink files to their appropriate locations
# Using symlinks instead of copying files allows for updates to this repo to be reflected on the user's system immediately

do_backup_file() {
  DEST_FILE=$1
  BACKUP_SUFFIX="old"

  # Backup existing file if it exists
  if [ -f "$DEST_FILE" ]; then
    echo "Backing up $DEST_FILE to $DEST_FILE.$BACKUP_SUFFIX"
    mv "$DEST_FILE" "$DEST_FILE.$BACKUP_SUFFIX" || true # Potentially overwrite existing backup
  fi
}

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

do_backup_and_symlink_file() {
  SRC_FILE=$1
  DEST_FILE=$2

  # Backup file if it exists
  do_backup_file "$DEST_FILE"

  # Symlink file
  do_symlink_file "$SRC_FILE" "$DEST_FILE"
}

do_backup_and_symlink_folder_files_matching_pattern() {
  SRC_FOLDER=$1
  DEST_FOLDER=$2
  PATTERN=$3

  # Backup and symlink files in folder
  for file in "$SRC_FOLDER"/$PATTERN; do
    FILE_NAME=$(basename "$file")
    DEST_FILE="$DEST_FOLDER/$FILE_NAME"
    do_backup_and_symlink_file "$file" "$DEST_FILE"
  done
}

do_backup_and_symlink_folder_files() {
  do_backup_and_symlink_folder_files_matching_pattern "$1" "$2" "*"
}

# Link secrets
SECRETS_FILE_NAME=".dotfiles_secrets"
SECRETS_FILE_SRC="$DECRYPTED_FOLDER/$SECRETS_FILE_NAME"
SECRETS_FILE_DEST="$HOME/$SECRETS_FILE_NAME"
echo "Installing secrets..."
do_backup_and_symlink_file "$SECRETS_FILE_SRC" "$SECRETS_FILE_DEST"

# Link bash-ftw profiles
echo "Installing bash-ftw profiles..."
# for each directory in DECRYPTED_FOLDER, find all files starting with .bashrc and symlink them to the same name in ~
for dir in "$DECRYPTED_FOLDER"/*; do
    if [ -d "$dir" ]; then
        # Override existing .bashrc files, don't worry about backing them up
        do_symlink_folder_files_matching_pattern "$dir" "$HOME" ".bashrc*"
    fi
done
# for each file in OPEN_FOLDER, symlink it to the same name in ~
for dir in "$OPEN_FOLDER"/*; do
    if [ -d "$dir" ]; then
        # Override existing .bashrc files, don't worry about backing them up
        do_symlink_folder_files_matching_pattern "$dir" "$HOME" ".bashrc*"
    fi
done

# Install crontab
# shellcheck disable=SC2016
CRONTAB_FILE="$OPEN_FOLDER/crontab"
echo "Installing crontab..."
crontab "$CRONTAB_FILE"

# Link git config
GIT_CONFIG_FILE="$OPEN_FOLDER/personal/.gitconfig"
echo "Installing git config..."
do_backup_and_symlink_file "$GIT_CONFIG_FILE" "$HOME/.gitconfig"

# Link .inputrc
INPUTRC_FILE="$OPEN_FOLDER/personal/.inputrc"
echo "Installing .inputrc..."
do_backup_and_symlink_file "$INPUTRC_FILE" "$HOME/.inputrc"

# Link ssh config
SSH_CONFIG_DIR="$HOME/.ssh"
mkdir -p "$SSH_CONFIG_DIR" || true
SSH_CONFIG_FILE="$DECRYPTED_FOLDER/ssh_config"
echo "Installing ssh config..."
do_backup_and_symlink_file "$SSH_CONFIG_FILE" "$SSH_CONFIG_DIR/config"

# Link rclone config
RCLONE_CONFIG_DIR="$HOME/.config/rclone"
mkdir -p "$RCLONE_CONFIG_DIR" || true
RCLONE_CONFIG_FILE="$DECRYPTED_FOLDER/rclone.conf"
echo "Installing rclone config..."
do_backup_and_symlink_file "$RCLONE_CONFIG_FILE" "$RCLONE_CONFIG_DIR/rclone.conf"
do_backup_and_symlink_file "$RCLONE_CONFIG_FILE" "$RCLONE_CONFIG_DIR/.rclone.conf" # Some versions of rclone use .rclone.conf instead of rclone.conf

# Link pcopy configs
PCOPY_CONFIG_SRC_DIR="$DECRYPTED_FOLDER/pcopy"
PCOPY_CONFIG_DEST_DIR="$HOME/.config/pcopy"
echo "Installing pcopy configs.."
do_backup_and_symlink_folder_files "$PCOPY_CONFIG_SRC_DIR" "$PCOPY_CONFIG_DEST_DIR"

# Link scripts
SCRIPTS_DIR="$HOME/.scripts"
mkdir -p "$SCRIPTS_DIR" || true
echo "Installing scripts to $SCRIPTS_DIR..."
# Override existing files, don't worry about backing them up
do_symlink_file "$REPO_LOCATION/scripts/bitwarden/bw_add_sshkeys.py" "$SCRIPTS_DIR/bw_add_sshkeys.py"
do_symlink_file "$REPO_LOCATION/scripts/ntfy/ntfy_send.sh" "$SCRIPTS_DIR/ntfy_send.sh"

# Make username alias to personal files
USERNAME=$(whoami)
do_symlink_file "$HOME/.bashrc.personal" "$HOME/.bashrc.$USERNAME" # Only needed for initial load, will point to Linux and Mac variants properly once loaded
