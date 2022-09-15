#!/usr/bin/env bash

read -n 1 -p "Would you like to use JetBrains IDEs, Microsoft IDEs, or both (J/M/B) " ans;
printf "\n"

case $ans in
    j|J)
        echo "Installing JetBrains IDEs..."
        sh jetbrains.sh;;
    m|M)
        echo "Installing Microsoft IDEs..."
        sh microsoft.sh;;
    b|B)
        echo "Installing JetBrains and Microsoft IDEs..."
        sh jetbrains.sh
        sh microsoft.sh;;
    *)
        exit;;
esac
