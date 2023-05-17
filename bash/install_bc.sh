#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color


# installer for the GNU bc arbitrary precision calculator language
# it is required by some freesurfer functionalities

function get_bc
{
    add2path=$1
    postfix=$2

    # fisrt of all download the deb package
    apt-get download bc
    
    # and now install the file
    bc_deb=$(ls bc*.deb)

    echo -e "${yellow}Installing ${bc_deb}${reset}"

    dpkg -x ${bc_deb} ~/

    if $add2path; then
        if $postfix; then
            echo export '$PATH':$HOME/usr/bin >> ~/.bashrc
        else
            echo export PATH=$HOME/usr/bin:'$PATH' >>~/.bashrc
        fi
    fi
}

function install_bc
{
    add2path=$1
    postfix=$2
    confirm=$3

    printf "${yellow}bc identification\n${reset}"

    if [ -z $(which bc) ]; then
        printf "${red}bc not found\n${reset}"
        read -p "Do you want install it? [y/n] " confirm

        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
            get_bc $add2path $postfix
        fi
    else
        printf "${green}bc already installed\n${reset}"
    fi
}

#install_bc true false -y