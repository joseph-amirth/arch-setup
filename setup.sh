#!/bin/bash
# Bash script to setup Arch.

source logging.sh
source steps.sh

read -sp "Enter password for sudo: " ROOT_PASSWD

wait_for_internet_connection

install_prerequisites

execute_command \
    --info "Installing paru (AUR helper)..." \
    --success "Installed paru." \
    -- install_aur_helper

setup_desktop_env

setup_terminal

install_file_browser

install_web_browser

setup_dotfiles

execute_command \
    --info "Installing custom scripts..." \
    --success "Installed custom scripts." \
    -- install_scripts
