#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

function get_julia
{
  add2path=$1

  if [[ "$OSTYPE" == "darwin"* ]]; then
    julia_version="1.1.0"
    url_julia="https://julialang-s3.julialang.org/bin/mac/x64/1.1/julia-$julia_version-mac64.dmg";
  else
    julia_version="1.0.1"
    url_julia="https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-$julia_version-linux-x86_64.tar.gz";
  fi

  echo -e "${yellow}Download julia from ${url_julia}${reset}"
  out_dir=$(echo $url_julia | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.gz)"
  wget $url_julia

  echo -e "${yellow}Unzip ${out_dir}${reset}"
  if [[ "$OSTYPE" == "darwin" ]]; then
    7za x $out_dir;
  else
    tar xzf $out_dir;
  fi

  if $add2path; then
    echo export PATH='$PATH':$PWD/julia-$julia_version/bin >> ~/.bashrc ;
  fi
  #export PATH=$PATH:$PWD/julia-$julia_version/bin
  rm $out_dir
}

function install_julia
{
  add2path=$1
  confirm=$2

  printf "${yellow}julia identification: ${reset}"
  if [ -z $(which julia) ]; then # not found
    echo -e "${red}NOT FOUND${reset}"
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ];then
      get_julia $add2path;
    else
      read -p "Do you want install it? [y/n] " confirm
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo -e "${red}Abort${reset}";
      else
        get_julia $add2path
      fi
    fi
  else
    echo -e "${green}FOUND${reset}"
  fi
}

#install_julia true -y
