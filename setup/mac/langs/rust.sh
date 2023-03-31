#!/usr/bin/env bash

# This script will install Cargo, the Rust package manager

echo "Installing Cargo..."
curl https://sh.rustup.rs -sSf | sh

# Add Cargo to PATH
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
