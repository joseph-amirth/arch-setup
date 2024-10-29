#!/bin/bash

brew install chezmoi
chezmoi init --apply https://github.com/joseph-amirth/dotfiles.git

wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
