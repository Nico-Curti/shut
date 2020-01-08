#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

function get_pip
{
  if [ -z $(which python) ]; then
    echo -e "${red}Python NOT FOUND${reset}"
  else
    url_pip="https://bootstrap.pypa.io/get-pip.py"
    echo -e "${yellow}Download get-pip from ${url_pip}${reset}"
    wget $url_pip

    echo -e "${yellow}Run get-pip${reset}"
    python $PWD/get-pip.py
  fi
}

#get_pip
