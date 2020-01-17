#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

function get_firefox
{
  add2path=$1

  if [[ "$OSTYPE" == "darwin"* ]]; then
    # TODO: check the correct url for MacOS
    url_firefox="https://download.mozilla.org/?product=firefox-latest&os=linux64";
  else
    url_firefox="https://download.mozilla.org/?product=firefox-latest&os=linux64";
  fi

  echo -e "${yellow}Download firefox from ${$url_firefox}${reset}"
  wget -O ./FirefoxSetup.tar.bz2 $url_firefox

  echo -e "${yellow}Unzip FirefoxSetup${reset}"
  tar xjf ./FirefoxSetup.tar.bz2

  if $add2path; then
    echo export PATH='$PATH':$PWD/firefox >> ~/.bashrc ;
  fi
  #export PATH=$PATH:$PWD/firefox
  rm FirefoxSetup.tar.bz2
}

function install_firefox
{
  add2path=$1
  confirm=$2

  printf "${yellow}firefox identification: ${reset}"
  if [ -z $(which firefox) ]; then # not found
    echo -e "${red}NOT FOUND${reset}"
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ];then
      get_firefox $add2path;
    else
      read -p "Do you want install it? [y/n] " confirm
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo -e "${red}Abort${reset}";
      else
        get_firefox $add2path
      fi
    fi
  else
    echo -e "${green}FOUND${reset}"
  fi
}

#install_firefox true -y
