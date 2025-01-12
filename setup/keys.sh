#!/usr/bin/env bash

# Generate new RSA SSH key
echo "Generating new SSH key..."
ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""
