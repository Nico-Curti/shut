#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

function get_make
{
  add2path=$1

  if [[ "$OSTYPE" == "darwin"* ]]; then
      url_make=""
  else
      url_make=""
  fi

  echo -e "${yellow}Download make from ${url_make}${reset}"
  out_dir=$(echo $url_make | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.gz)"
  wget $url_make

  echo -e "${yellow}Unzip ${out_dir}${reset}"
  tar xzf $out_dir
  mv $out $out-sources
  cd $out-sources
  ./contrib/download_prerequisites
  cd ..
  mkdir -p objdir
  cd objdir

  if $add2path; then
    echo export PATH='$PATH':$PWD/$out/bin/ >> ~/.bashrc
  fi
  # export PATH=$PATH:$PWD/$out/bin/
}

function install_make
{
  add2path=$1
  confirm=$2

  printf "${yellow}Make identification: ${reset}"
  if [ -z $(which make) ]; then
    # NO make
    echo -e "${red}NOT FOUND${reset}"
    if [ ! -z $(which conda) ]; then
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        conda install -y -c anaconda make
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
          conda install -y -c anaconda make
        fi
      fi
    else
      echo -e "${red}Make available only with conda${reset}"
      # exit 1
    fi
  else
    echo -e "${green}FOUND${reset}";
  fi
}

#install_make true -y
