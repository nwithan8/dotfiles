#!/usr/bin/env bash

GLOBAL_PYTHON="3.10.0"
echo "Installing Python versions..."
curl https://pyenv.run | bash
eval "$(pyenv init -)"

PYTHON_VERSIONS="3 3.10 3.9 3.8 3.7" # Install latest of all listed Python versions
for V in $PYTHON_VERSIONS; do
  echo "Installing Python $V..."
  pyenv install "$V":latest
done
pyenv global "$GLOBAL_PYTHON"
