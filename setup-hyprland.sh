#!/bin/bash

sudo pacman -S hyprland hyprpaper waybar wl-clipboard dunst ddcutil

for SCRIPT in $(find ~/.config/hypr/scripts -type f)
do
    SCRIPT_NAME=$(basename --suffix=".sh" "$SCRIPT")
    ln -sf $SCRIPT ~/.local/bin/$SCRIPT_NAME
done
