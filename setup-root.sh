#!/bin/bash
# Bash script to setup an arch system (not user).

pacman -S --noconfirm sudo zsh which
chsh -s $(which zsh)
sed -i '/%wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers
sed -i '/\[multilib\]/{N;s/^#//}' /etc/pacman.conf
