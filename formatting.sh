#!/bin/bash
# Bash script with functions for pretty printing.

# ANSI escape codes for colors.
red='\033[31m'
green='\033[32m'
blue='\033[34m'
reset='\033[0m'

# Echo wrappers.
function infoln() {
    echo -e "${blue}[INFO]${reset} $1"
}

function successln() {
    echo -e "${green}[SUCCESS]${reset} $1"
}

function errorln() {
    echo -e "${red}[ERROR]${reset} $1"
}

# Terminal output manipulators.
function clear_line() {
    echo -ne "\e[1A\e[K"
}
