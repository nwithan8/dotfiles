## help - Display help about make targets for this Makefile
help:
	@cat Makefile | grep '^## ' --color=never | cut -c4- | sed -e "`printf 's/ - /\t- /;'`" | column -s "`printf '\t'`" -t

## fresh-install - Run all fresh-install steps
# @param private_key_path - Path to GPG private key
fresh-install: |
	make set_up_shell
	make install_apt
	make install_brew
	make set_up_gpg "$(private_key_path)"
	make install_git
	make decrypt_private_files
	make set_up_ssh_keys
	make install_bash_profile
	make install_dotfiles
	make install_notes
	make install_github
	make clone_repos
	make install_langs
	make install_ides

## set_up_shell - Set up preferred shell
set_up_shell:
	sh shell.sh

## install_bash_profile - Install and set up bash profile
install_bash_profile:
	sh ../bash_profile.sh "$(shell pwd)/../.." # This works because the user has to be in the linux directory to run this command

## install_apt - Install packages via apt
install_apt:
	sh apt/packages.sh

## install_brew - Install Homebrew and packages
install_brew:
	sh ../brew.sh

## decrypt_private_files - Decrypt private files
decrypt_private_files:
	git-crypt unlock

## set_up_extras - Run extra utilities
set_up_extras:
	sh ../extras.sh

## install_dotfiles - Copy files to home directory
install_dotfiles:
	sh ../files.sh "$(shell pwd)/../.." # This works because the user has to be in the linux directory to run this command

## install_notes - Set up Obsidian notes vault
install_notes:
	sh ../notes.sh

## install_git - Set up Git
install_git:
	sh git.sh

## install_github - Set up GitHub
install_github:
	sh ../github.sh

## set_up_gpg - Set up GPG
# @param private_key_path - Path to private key
set_up_gpg:
	sh ../gpg.sh "$(private_key_path)" "$(shell pwd)/../.." # This works because the user has to be in the linux directory to run this command

## install_ides - Install IDEs
install_ides:
	sh ../ides.sh

## install_jetbrains - Install JetBrains IDEs
install_jetbrains:
	sh ../jetbrains.sh

## set_up_ssh_keys - Set up SSH keys
set_up_ssh_keys:
	sh ../keys.sh

## install_langs - Install required programming languages and SDKs
install_langs:
	sh ../langs/python.sh
        sh ../langs/php.sh
        sh ../langs/node.sh
        sh ../langs/ruby.sh
        sh ../langs/java.sh
        sh ../langs/go.sh
        sh ../langs/net.sh
        sh ../langs/rust.sh

## install_dotnet - Install .NET SDKs
install_dotnet:
	sh ../langs/net.sh

## install_node - Install Node.js and NPM
install_node:
	sh ../langs/node.sh

## install_python - Install Python and Pip
install_python:
	sh ../langs/python.sh

## install_ruby - Install Ruby and Gems
install_ruby:
	sh ../langs/ruby.sh

## install_go - Install Go
install_go:
	sh ../langs/go.sh

## install_java - Install Java
install_java:
	sh ../langs/java.sh

## install_php - Install PHP
install_php:
	sh ../langs/php.sh

## install_microsoft - Install Microsoft IDEs (VSCode and Visual Studio)
install_microsoft:
	sh ../microsoft.sh

## clone_repos - Clone GitHub repositories
clone_repos:
	sh ../repos.sh


.PHONY: first-time all help install_bash_profile set_up_extras install_dotfiles install_git install_github set_up_gpg install_ides install_jetbrains set_up_ssh_keys install_langs install_dotnet install_node install_python install_ruby install_go install_java install_php install_microsoft clone_repos set_up_shell decrypt_private_files


