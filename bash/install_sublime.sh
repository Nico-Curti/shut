#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

function get_sublime
{
  add2path=$1

  if [[ "$OSTYPE" == "darwin"* ]]; then
   url_sublime="https://download.sublimetext.com/Sublime%20Text%20Build%203176.dmg"
  else
   url_sublime="https://download.sublimetext.com/sublime_text_3_build_3176_x64.tar.bz2"
  fi

  echo -e "${yellow}Download SublimeText3 from ${url_sublime}${reset}"
  out_dir=$(echo $url_sublime | rev | cut -d'/' -f 1 | rev)
  wget $url_sublime

  echo -e "${yellow}Unzip ${out_dir}${reset}"
  if [[ "OSTYPE" == "darwin" ]]; then
    7za x $out_dir;
  else
    tar xvjf $out_dir
  fi
  rm -rf $out_dir
  if $add2path; then
    echo export PATH='$PATH':$PWD/sublime_text_3 >> ~/.bashrc
  fi
  #export PATH='$PATH':$PWD/sublime_text_3/
}

function install_sublime
{
  add2path=$1
  confirm=$2

  call=$( sublime_text -v 2> /dev/null )
  printf "${yellow}SublimeText3 identification: ${reset}"
  if [[ -z $call ]]; then
    echo -e "${red}NOT FOUND${reset}";
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
      get_sublime $add2path;
    else
      read -p "Do you want install it? [y/n] " confirm;
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo -e "${red}Abort${reset}";
      else
        get_sublime $add2path;
      fi
    fi
  else
    echo -e "${green}FOUND${reset}"
  fi
  # end sublime not found
}

#install_sublime true -y
