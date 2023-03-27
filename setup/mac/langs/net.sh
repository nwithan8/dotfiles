#!/usr/bin/env bash

DOTNET_VERSIONS="Current 7.0 6.0 5.0 3.1"
echo "Installing C# and .NET..."
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
for V in $DOTNET_VERSIONS; do
  echo "Installing .NET $V..."
  ./dotnet-install.sh --channel "$V" --verbose
done
rm dotnet-install.sh
