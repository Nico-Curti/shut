#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

function get_7zip
{
  add2path=$1

  if [[ "$OSTYPE" == "darwin"* ]]; then
    url_7zip="https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2";
  else
    url_7zip="https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2";
  fi

  echo -e "${yellow}Download 7zip from ${$url_7zip}${reset}"
  out_dir=$(echo $url_7zip | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.bz2)"
  wget $url_7zip

  echo -e "${yellow}Unzip ${out_dir}${reset}"
  tar jxvf $out_dir

  out_dir=$(echo $out | cut -d'_' -f 1,2)
  cd $out_dir/
  cp makefile.linux_gcc6_sanitize makefile.linux
  make -j all_test
  cd ..
  if $add2path; then
    echo export PATH='$PATH':$PWD/$out_dir/bin >> ~/.bashrc ;
  fi
  #export PATH=$PATH:$PWD/$out_dir/bin
  rm $out_dir
}

function install_7zip
{
  add2path=$1
  confirm=$2

  printf "${yellow}7zip identification: ${reset}"
  if [ -z $(which 7za) ]; then # not found
    echo -e "${red}NOT FOUND${reset}"
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ];then
      get_7zip $add2path;
    else
      read -p "Do you want install it? [y/n] " confirm
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo -e "${red}Abort${reset}";
      else
        get_7zip $add2path
      fi
    fi
  else
    echo -e "${green}FOUND${reset}"
  fi
}

#install_7zip true -y
