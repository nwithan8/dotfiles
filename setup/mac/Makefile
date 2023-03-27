## help - Display help about make targets for this Makefile
help:
	@cat Makefile | grep '^## ' --color=never | cut -c4- | sed -e "`printf 's/ - /\t- /;'`" | column -s "`printf '\t'`" -t

## all - Run all main steps
all: |
	shell
	sh all.sh "$(shell pwd)/../.." # This works because the user has to be in the mac directory to run this command

## bashftw - Install and set up bash-ftw
bashftw:
	sh bashftw.sh

## brew - Install brew packages
brew:
	sh brew.sh

## extras - Run extra utilities
extras:
	sh extras.sh

## files - Copy files to home directory
files:
	sh files.sh "$(shell pwd)/../.." # This works because the user has to be in the mac directory to run this command

## git - Set up Git
git:
	sh git.sh

## github - Set up GitHub
github:
	sh github.sh

## ides - Install IDEs
ides:
	sh ides.sh

## jetbrains - Install JetBrains IDEs
jetbrains:
	sh jetbrains.sh

## keys - Set up SSH keys
keys:
	sh keys.sh

## langs - Install required programming languages and SDKs
langs:
	sh langs.sh

## langs-net - Install .NET SDKs
langs-net:
	sh langs/net.sh

## langs-node - Install Node.js and NPM
langs-node:
	sh langs/node.sh

## langs-python - Install Python and Pip
langs-python:
	sh langs/python.sh

## langs-ruby - Install Ruby and Gems
langs-ruby:
	sh langs/ruby.sh

## langs-go - Install Go
langs-go:
	sh langs/go.sh

## langs-java - Install Java
langs-java:
	sh langs/java.sh

## langs-php - Install PHP
langs-php:
	sh langs/php.sh

## microsoft - Install Microsoft IDEs (VSCode and Visual Studio)
microsoft:
	sh microsoft.sh

## repos - Clone GitHub repositories
repos:
	sh repos.sh

## shell - Change ZSH shell to Bash
shell:
	zsh shell.sh



