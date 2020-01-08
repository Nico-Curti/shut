#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

function get_ninja
{
  add2path=$1
  version="1.9.0"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    url_ninja="https://github.com/ninja-build/ninja/releases/download/v$version/ninja-mac.zip"
  else
    url_ninja="https://github.com/ninja-build/ninja/releases/download/v$version/ninja-linux.zip"
  fi

  echo -e "${yellow}Download ninja-build from ${url}${reset}"
  name=$(echo $url_ninja | rev | cut -d'/' -f 1 | rev)
  out="$(basename $name .zip)"
  wget $url_ninja

  mkdir -p ninja
  mv $name ninja/
  cd ninja

  echo -e "${yellow}Unzip ${name}${reset}"
  if [ -x "unzip" ]; then
    unzip $name;
  else
    7za x $name;
  fi
  rm -rf $name
  cd ..

  if $add2path; then
    echo export PATH='$PATH':$PWD/ninja >> ~/.bashrc;
  fi
  #export PATH='$PATH':$PWD/ninja
}

function install_ninja
{
  add2path=$1
  confirm=$2

  printf "${yellow}ninja-build identification: ${reset}"
  if [ ! -z $(which ninja) ]; then
    echo -e "${green}FOUND${reset}"
  else
    echo -e "${red}NOT FOUND${reset}"
    if [ ! -z $(which conda) ]; then
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        conda install -y -c anaconda ninja;
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
          conda install -y -c anaconda ninja;
        fi
      fi
    else
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_ninja $add2path;
      else
        read -p "Do you want install it? [y/n] " confirm;
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
          get_ninja $add2path;
        fi
      fi
      # end function installer
    fi
    # end python found
  fi
  # end ninja not found
}

#install_ninja true -y
