#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color


function get_cmake
{
  add2path=$1
  postfix=$2
  cmake_version="3.16.2"
  cmake_up_version="$(echo $cmake_version | cut -d'.' -f 1,2)"

  if [[ "$OSTYPE" == "darwin"* ]]; then
   url_cmake="https://cmake.org/files/v$cmake_up_version/cmake-$cmake_version-Darwin-x86_64.tar.gz"
  else
   url_cmake="https://cmake.org/files/v$cmake_up_version/cmake-$cmake_version-Linux-x86_64.tar.gz"
  fi

  echo -e "${yellow}Download CMAKE from ${url_cmake}${reset}"
  out_dir=$(echo $url_cmake | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.gz)"
  wget $url_cmake

  echo -e "${yellow}Unzip ${out_dir}${reset}"
  tar zxf $out_dir
  rm -rf $out_dir
  mv $out cmake
  if $add2path; then
    if $postfix; then
      echo export PATH='$PATH':$PWD/cmake/bin >> ~/.bashrc
    else
      echo export PATH=$PWD/cmake/bin:'$PATH' >> ~/.bashrc
    fi
  fi
  #export PATH='$PATH':$PWD/cmake/bin
}

function install_cmake
{
  add2path=$1
  confirm=$2
  postfix=$3

  printf "${yellow}cmake identification: ${reset}"
  if [ -z $(which cmake) ]; then
    echo -e "${red}NOT FOUND${reset}";
    if [ ! -z $(which conda) ]; then
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        conda install -y -c anaconda cmake;
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
          conda install -y -c anaconda cmake;
        fi
      fi
      # end conda installer
    else
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_cmake $add2path $postfix;
      else
        read -p "Do you want install it? [y/n] " confirm;
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
          get_cmake $add2path $postfix;
        fi
      fi
      # end function installer
    fi
    # end python found
  else
    echo -e "${green}FOUND${reset}"
    ver=$(echo $(cmake --version) | cut -d' ' -f 3)
    ver=$(echo "${ver//./}")
    currver=$(echo "${cmake_version//./}")
    if [ $ver -lt $currver ]; then
      echo -e "${red}Old CMake version found${reset}"
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_cmake $add2path $postfix;
      else
        read -p "Do you want install it? [y/n] " confirm;
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
          get_cmake $add2path $postfix;
        fi
      fi
    fi
  fi
  # end cmake not found
}

#install_cmake true -y
