#!/usr/bin/env bash

# This script SHOULD install both the SDK and runtime for each version of .NET
# If you can't run a .NET app, you may need to install the runtime
# If you can't build a .NET app, you may need to install the SDK
# https://dotnet.microsoft.com/en-us/download/dotnet

# Alternate method for Apple Silicon
if [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
    echo "Apple Silicon detected, using brew to install .NET..."
    if [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
	echo "Early-gen chip detected, need to install Rosetta 2 first"
	softwareupdate --install-rosetta --agree-to-license	
    fi
    brew install dotnet
    exit 0
fi

# .NET versions we want to install
declare -a NetVersions=("9.0" "8.0" "7.0" "6.0")

# Download dotnet-install.sh
echo "Downloading dotnet-install.sh script..."
curl -sSL https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh

# Install each .NET version
echo "Installing .NET versions..."
for version in ${NetVersions[@]}; do
    echo "Installing .NET $version..."
    sudo bash ./dotnet-install.sh -c "$version"
done

# Remove dotnet-install.sh
echo "Removing dotnet-install.sh script..."
rm dotnet-install.sh
