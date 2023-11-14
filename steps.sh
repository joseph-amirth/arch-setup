#!/bin/bash
# Bash script with functions for setting up Arch.

function my_sudo() {
    echo -e "$ROOT_PASSWD" | sudo -Sk "$@"
}

function wait_for_internet_connection() {
    execute_command \
        --info "Checking for internet connection..." \
        --success "Internet connection established." \
        --error "Could not establish internet connection. Aborting setup." \
        --abort_if_error \
        -- ping -q -c1 -w1 8.8.8.8
}

function pacman_install() {
    PACKAGES="$@"
    PACKAGES_MSG=${PACKAGES// /, } # For pretty printing list of packages in messages.
    execute_command \
        --info "Installing $PACKAGES_MSG with pacman..." \
        --success "Installed $PACKAGES_MSG with pacman." \
        --error "Error while installing $PACKAGES_MSG with pacman." \
        -- my_sudo pacman -S --noconfirm $PACKAGES
}

function install_prerequisites() {
    # Install various basic prereqs and package managers.
    pacman_install git

    # To make makepkg work.
    pacman_install base-devel

    pacman_install npm

    # To install cargo.
    pacman_install rustup
    execute_command \
        --info "Installing rust with rustup..." \
        --success "Installed rust with rustup." \
        -- rustup default stable

    pacman_install go

    pacman_install python-pip
}

function install_aur_helper() {
    # Install paru (AUR helper).
    git clone https://aur.archlinux.org/paru.git ~/aurtemp
    cd ~/aurtemp
    makepkg --syncdeps
    my_sudo pacman -U --noconfirm *.pkg.tar.zst
    cd ~ && rm -rf ~/aurtemp
}

function setup_desktop_env() {
    # Install X.
    pacman_install xorg

    # Install and enable display manager.
    pacman_install lightdm lightdm-slick-greeter
    my_sudo systemctl enable lightdm.service

    # Install window manager and compositor.
    pacman_install bspwm picom sxhkd rofi polybar feh

    # Install icon theme for rofi.
    pacman_install papirus-icon-theme

    # Install sound server.
    pacman_install pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack alsa-utils

    # Install bluetooth protocol stack.
    pacman_install bluez bluez-utils

    # Install maim for screenshots.
    pacman_install maim

    # Install libnotify and notification server.
    pacman_install libnotify dunst
}

function setup_terminal() {
    # zsh is already installed at this point and the login shell for the user is already zsh.

    # Install oh-my-zsh (zsh plugin manager).
    execute_command \
        --info "Installing oh-my-zsh (zsh plugin manager)..." \
        --success "Successfully installed oh-my-zsh." \
        -- sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Install powerlevel10k (zsh theme).
    execute_command \
        --info "Installing powerlevel10k (zsh theme)..." \
        --success "Successfully installed powerlevel10k." \
        -- git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    # Install zsh-syntax-highlighting and zsh-autosuggestions (zsh plugins).
    execute_command \
        --info "Installing zsh-autosuggestions (zsh plugin)..." \
        --success "Successfully installed zsh-autosuggestions." \
        -- git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    execute_command \
        --info "Installing zsh-syntax-highlighting (zsh plugin)..." \
        --success "Successfully installed zsh-syntax-highlighting." \
        -- git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    # Install Neovim and Kitty.
    pacman_install neovim kitty

    # Install powerline-fonts for the agnoster theme of zsh.
    pacman_install powerline-fonts

    # Install JetBrains Mono nerd font.
    pacman_install ttf-jetbrains-mono-nerd
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
    pacman_install firefox
}

function setup_dotfiles() {
    # Install and set up chezmoi and dotfiles.
    pacman_install chezmoi
    execute_command \
        --info "Setting up dotfiles with chezmoi..." \
        --success "Successfully setup dotfiles with chezmoi." \
        -- chezmoi init --apply https://github.com/joseph-amirth/.dotfiles.git
}

function install_scripts() {
    mkdir -p ~/.local/bin
    for SCRIPT in $(find ~/.config/scripts -type f); do
        SCRIPT_NAME=$(basename --suffix=".sh" "$SCRIPT")
        ln -sf $SCRIPT ~/.local/bin/$SCRIPT_NAME
    done
}
