#!/bin/sh

# MacOS-specific setup steps to run after all other setup steps

# Link mods config location to Application Support
MODS_APP_SUPPORT_FOLDER="$HOME/Library/Application Support/mods"
MODS_CONFIG_FOLDER="$HOME/.config/mods"
rm -r "$MODS_APP_SUPPORT_FOLDER" || true
ln -s "$MODS_CONFIG_FOLDER" "$MODS_APP_SUPPORT_FOLDER"
