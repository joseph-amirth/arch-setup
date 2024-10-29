#!/bin/bash

sudo pacman -S hyprland hyprpaper hyprshot waybar rofi-wayland wl-clipboard dunst

sudo pacman -S xorg mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
sudo pacman -S libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau

sudo pacman -S pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack alsa-utils
