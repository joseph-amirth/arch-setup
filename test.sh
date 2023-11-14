#!/bin/bash

source logging.sh

execute_command \
    --info "Installing oh-my-zsh (zsh plugin manager)..." \
    --success "Successfully installed oh-my-zsh." \
    -- sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
