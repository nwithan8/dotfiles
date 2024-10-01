### Process

Run `make all private_key_path=/path/to/private/gpg/key` to run all setup processes.

This will, in order:
- Set the shell to Bash
- Install Homebrew and all required packages
- Install BashFTW
- Generate SSH keys
- Import provided GPG key
- Decrypt all encrypted files using the provided GPG key
- Symlink all dotfiles to the home directory
- Install git
- Set up GitHub authentication, register SSH key with GitHub and install GitHub Copilot
- Clone all required repositories
- Install all required programming languages and tools
- Install all required IDEs
