#!/usr/bin/env bash

GLOBAL_PYTHON="3.13.2"

echo "Installing Python versions..."
curl https://pyenv.run | bash
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init -)"

PYTHON_VERSIONS="3 3.13 3.12 3.11 3.10 3.9 3.8 3.7" # Install latest of all listed Python versions
for V in $PYTHON_VERSIONS; do
  echo "Installing Python $V..."
  pyenv install "$V":latest
done
pyenv global "$GLOBAL_PYTHON"
