#!/bin/bash
# Bash script to setup an arch system (not user).

pacman -S sudo zsh which
chsh -s $(which zsh)
sed '/%wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers
