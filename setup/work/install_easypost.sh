#!/usr/bin/env bash

# Override default (personal) settings with Easypost-specific settings
REPO_LOCATION=$1
WORK_FOLDER="easypost"

source "$REPO_LOCATION/setup/.files_helper"

# Override .gitconfig
GIT_CONFIG_FILE="$SECRET_FOLDER/$WORK_FOLDER/.gitconfig"
echo "Installing git config..."
do_backup_and_symlink_file "$GIT_CONFIG_FILE" "$HOME/.gitconfig"

# Override ssh config
SSH_CONFIG_DIR="$HOME/.ssh"
mkdir -p "$SSH_CONFIG_DIR" || true
SSH_CONFIG_FILE="$SECRET_FOLDER/$WORK_FOLDER/ssh_config"
echo "Installing ssh config..."
do_backup_and_symlink_file "$SSH_CONFIG_FILE" "$SSH_CONFIG_DIR/config"

# Add EasyPost-specific bashrc files to import list
echo "Adding EasyPost-specific bashrc files to import list..."
do_add_bashrc_import_groups "easypost epnharris"