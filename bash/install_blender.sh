#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

function get_blender
{
  add2path=$1
  #modules=$2
  version="2.81"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    url_blender="https://ftp.halifax.rwth-aachen.de/blender/release/Blender${version}/blender-${version}-macOS-10.6.tar.gz"
  else
    url_blender="https://ftp.halifax.rwth-aachen.de/blender/release/Blender${version}/blender-${version}-linux-glibc219-x86_64.tar.bz2"
  fi

  echo -e "${yellow}Download blender from ${url_blender}${reset}"
  out_dir=$(echo $url_blender | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.bz2)"
  ver=$(echo $out | cut -d'-' -f 2)
  wget $url_blender

  echo -e "${yellow}Unzip ${out_dir}${reset}"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    tar xzf $out_dir
  else
    tar jxvf $out_dir
  fi
  rm -rf $out_dir
  mv $out blender
  if $add2path; then
    echo export PATH='$PATH':$PWD/blender/ >> ~/.bashrc ;
  fi
  #export PATH='$PATH':$PWD/blender/

  url_pip="https://bootstrap.pypa.io/get-pip.py"
  cd blender/$ver/python/bin
  echo -e "${yellow}Download get-pip from ${url_pip}${reset}"
  wget $url_pip

  echo -e "${yellow}Run get-pip${reset}"
  bpy=$(find -name "python*")
  $bpy get-pip.py
  rm get-pip.py

  for module in "${@:2}"; do
    ./pip install $module
  done
}

function install_blender
{
  add2path=$1
  confirm=$2
  modules=$3

  printf "${yellow}Blender identification: ${reset}"
  if [ -z $(which blender) ]; then
    echo -e "${red}NOT FOUND${reset}"
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
      get_blender $add2path $modules;
    else
      read -p "Do you want install it? [y/n] " confirm
      if [ "$CONFIRM" == "n" ] || [ "$CONFIRM" == "N" ]; then
        echo -e "${red}Abort${reset}";
      else
        get_blender $add2path $modules;
      fi
    fi
  else
    echo -e "${green}FOUND${reset}";
  fi
}

#install_blender true -y numpy scipy
