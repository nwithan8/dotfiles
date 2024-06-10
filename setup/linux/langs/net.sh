#!/usr/bin/env bash

# This script SHOULD install both the SDK and runtime for each version of .NET
# If you can't run a .NET app, you may need to install the runtime
# If you can't build a .NET app, you may need to install the SDK
# https://dotnet.microsoft.com/en-us/download/dotnet

DOTNET_VERSIONS="8.0 7.0 6.0 5.0 3.1"
echo "Installing C# and .NET..."
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
for V in $DOTNET_VERSIONS; do
  echo "Installing .NET $V..."
  ./dotnet-install.sh --channel "$V" --verbose
done
rm dotnet-install.sh
