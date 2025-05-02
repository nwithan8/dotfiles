#!/bin/sh

# Install the PairDrop CLI on MacOS
github_link=$(curl -s "https://api.github.com/repos/schlagmichdoch/PairDrop/releases/latest" | jq -r '.assets[].browser_download_url')
wget "$github_link"

# Download the latest release
# download_latest_github_release "schlagmichdoch/PairDrop"

# Unzip to the ~/.bin directory
sudo unzip pairdrop-cli.zip -d ~/.bin/pairdrop-cli/

# Copy the config file to the ~/.config directory
sudo cp ~/.bin/pairdrop-cli/.pairdrop-cli-config.example ~/.config/.pairdrop-cli-config

# Link the config file back to ~/.bin
sudo ln -s ~/.config/.pairdrop-cli-config ~/.bin/pairdrop-cli/.pairdrop-cli-config

# Make the binary executable
sudo chmod +x ~/.bin/pairdrop-cli/pairdrop

# Link the binary to the ~/.bin directory (add to PATH)
sudo ln -s ~/.bin/pairdrop-cli/pairdrop ~/.bin//pairdrop
