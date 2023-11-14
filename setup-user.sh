#!/bin/bash
# Bash script to setup a user in Arch.

source logging.sh
source steps.sh

read -sp "Enter password for sudo: " ROOT_PASSWD
LOG_FILE=$(mktemp)

wait_for_internet_connection

install_prerequisites

execute_command \
    --info "Installing paru (AUR helper)..." \
    --success "Installed paru." \
    -- install_aur_helper

setup_desktop_env

setup_terminal

execute_command \
    --info "Installing ranger and plugins (file manager)..." \
    --success "Installed ranger." \
    -- install_file_browser

install_web_browser

setup_dotfiles

execute_command \
    --info "Installing custom scripts..." \
    --success "Installed custom scripts." \
    -- install_scripts
