#!/bin/bash

git clone https://aur.archlinux.org/paru.git ~/aurtemp
cd ~/aurtemp
makepkg --syncdeps
sudo pacman -U --noconfirm *.pkg.tar.zst
cd ~ && rm -rf ~/aurtemp
