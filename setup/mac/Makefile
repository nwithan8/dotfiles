## help - Display help about make targets for this Makefile
help:
	@cat Makefile | grep '^## ' --color=never | cut -c4- | sed -e "`printf 's/ - /\t- /;'`" | column -s "`printf '\t'`" -t

## all - Run all main steps
all: |
	shell
	sh all.sh

## shell - Change ZSH shell to Bash
shell:
	zsh shell.sh

## bashftw - Install and set up bash-ftw
bashftw:
	sh bashftw.sh

## brew - Install brew packages
brew:
	sh brew.sh

## github - Set up GitHub
github:
	sh github.sh

## keys - Set up SSH keys
keys:
	sh keys.sh

## jetbrains - Install JetBrains IDEs
jetbrains:
	sh jetbrains.sh

## microsoft - Install Microsoft IDEs (VSCode and Visual Studio)
microsoft:
	sh microsoft.sh

## langs - Install required programming languages and SDKs
langs:
	sh langs.sh

## repos - Clone GitHub repositories
repos:
	sh repos.sh

## extras - Run extra utilities
extras:
	sh extras.sh



