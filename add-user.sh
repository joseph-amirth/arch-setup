#!/bin/bash
# Bash script for creating a user.

if [[ -z $1 ]]; then
    read -p "Enter the name of the new user: " USER
else
    USER=$1
fi

useradd -m -G wheel -s $(which zsh) $USER
passwd $USER
