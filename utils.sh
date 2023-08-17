# ANSI escape codes for colors.
red='\033[31m'
green='\033[32m'
blue='\033[34m'
reset='\033[0m'

# Echo wrappers.
function infoln() {
    echo -e "${blue}$1${reset}"
}

function successln() {
    echo -e "${green}$1${reset}"
}

function errorln() {
    echo -e "${red}$1${reset}"
}
