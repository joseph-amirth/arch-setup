#!/bin/bash

sudo pacman -S git base-devel npm rustup go python-pip

rustup default stable

SCRIPTS_DIR=$(dirname $(realpath $0))
source $SCRIPTS_DIR/install_aur.sh
