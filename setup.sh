#!/bin/bash
# Bash script to setup Arch.

source utils.sh

function wait_for_internet_connection() {
    # Wait for internet connection to be established.
    while ! ping -c1 8.8.8.8 &> /dev/null
    do
        errorln "Ping failed - trying again in 1 second(s)."
        errorln "Check internet connection."
        sleep 1
    done
    
    successln "Internet connection established."
}

function install_prerequisites() {
    # Install various basic prereqs and package managers.
    sudo pacman -S --noconfirm git

    # To make makepkg work.
    sudo pacman -S --noconfirm base-devel

    sudo pacman -S --noconfirm npm

    # To install cargo.
    sudo pacman -S --noconfirm rustup
    rustup default stable

    sudo pacman -S go --noconfirm

    sudo pacman -S python-pip --noconfirm
}

function install_aur_helper() {
    # Install paru (AUR helper).
    git clone https://aur.archlinux.org/paru.git ~/aurtemp
    cd ~/aurtemp
    makepkg --syncdeps
    sudo pacman -U --noconfirm *.pkg.tar.zst
    cd ~ && rm -rf ~/aurtemp
}

function setup_desktop_env() {
    # Install X.
    sudo pacman -S --noconfirm xorg

    # Install and enable display manager.
    sudo pacman -S --noconfirm lightdm lightdm-slick-greeter
    sudo systemctl enable lightdm.service

    # Install window manager and compositor.
    sudo pacman -S --noconfirm bspwm picom sxhkd rofi polybar feh

    # Install icon theme for rofi.
    sudo pacman -S --noconfirm papirus-icon-theme

    # Install sound server.
    sudo pacman -S --noconfirm pipewire-audio pipewire-alsa pipewire-pulese pipewire-jack alsa-utils

    # Install and setup backlight management.
    sudo usermod -aG video $(whoami)
    sudo echo "ACTION==\"add\", SUBSYSTEM==\"backlight\", RUN+=\"/bin/chgrp video $sys$devpath/brightness\", RUN+=\"/bin/chmod g+w $sys$devpath/brightness" > /etc/udev/rules.d/backlight.rules
    sudo pacman -S --noconfirm light

    # Install bluetooth protocol stack.
    sudo pacman -S --noconfirm bluez bluez-utils

    # Install maim for screenshots.
    sudo pacman -S --noconfirm maim

    # Install libnotify and notification server.
    sudo pacman -S --noconfirm libnotify dunst
}

function setup_terminal() {
    # Install zsh and set it as the default shell.
    sudo pacman -S --noconfirm zsh
    chsh -s $(which zsh)

    # Install oh-my-zsh (zsh plugin manager).
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Install powerlevel10k (zsh theme).
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    # Install zsh-syntax-highlighting and zsh-autosuggestions (zsh plugins).
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    # Install Neovim and Kitty.
    sudo pacman -S --noconfirm neovim kitty

    # Install powerline-fonts for the agnoster theme of zsh.
    sudo pacman -S --noconfirm powerline-fonts

    # Install JetBrains Mono nerd font.
    sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd
}

function install_file_browser() {
    # Install ranger (file manager).
    paru -S --noconfirm ranger-git

    # Install devicons for ranger.
    git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

    # Install pillow for ranger image preview. 
    pip install pillow
}

function install_web_browser() {
    # Install firefox.
    sudo pacman -S --noconfirm firefox
}

function setup_dotfiles() {
    # Install and set up chezmoi and dotfiles.
    sudo pacman -S --noconfirm chezmoi
    chezmoi init --apply https://github.com/joseph-amirth/.dotfiles.git
}

function install_scripts() {
    mkdir -p ~/.local/bin
    for SCRIPT in $(find ~/.config/scripts -type f); do
        SCRIPT_NAME=$(basename --suffix=".sh" "$SCRIPT")
        ln -sf $SCRIPT ~/.local/bin/$SCRIPT_NAME
    done
}

wait_for_internet_connection

install_prerequisites

install_aur_helper

setup_desktop_env

setup_terminal

install_file_browser

install_web_browser

setup_dotfiles

install_scripts
