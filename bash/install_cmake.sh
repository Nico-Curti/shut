#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

cmake_version="3.12.1"

function get_cmake
{
  add2path=$1
  cmake_up_version="$(echo $cmake_version | cut -d'.' -f 1,2)"

  if [[ "$OSTYPE" == "darwin"* ]]; then
   url_cmake="https://cmake.org/files/v$cmake_up_version/cmake-$cmake_version-Darwin-x86_64.tar.gz"
  else
   url_cmake="https://cmake.org/files/v$cmake_up_version/cmake-$cmake_version-Linux-x86_64.tar.gz"
  fi

  echo "Download CMAKE from " $url_cmake
  out_dir=$(echo $url_cmake | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.gz)"
  wget $url_cmake

  echo "Unzip" $out_dir
  tar zxf $out_dir
  rm -rf $out_dir
  mv $out cmake
  if $add2path; then
    echo export PATH='$PATH':$PWD/cmake/bin >> ~/.bashrc ;
  fi
  #export PATH='$PATH':$PWD/cmake/bin
}

function install_cmake
{
  add2path=$1
  confirm=$2

  printf "cmake identification: "
  if [ -z $(which cmake) ]; then
    echo ${red}"NOT FOUND"${reset};
    if [ ! -z $(which conda) ]; then
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        conda install -y -c anaconda cmake;
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          conda install -y -c anaconda cmake;
        fi
      fi
      # end conda installer
    else
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_cmake $add2path;
      else
        read -p "Do you want install it? [y/n] " confirm;
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          get_cmake $add2path;
        fi
      fi
      # end function installer
    fi
    # end python found
  else
    echo ${green}"FOUND"${reset}
    ver=$(echo $(cmake --version) | cut -d' ' -f 3)
    ver=$(echo "${ver//./}")
    currver=$(echo "${cmake_version//./}")
    echo $ver
    echo $currver
    if [ $ver -lt $currver ]; then
      echo ${red}"Old CMake version found"${reset}
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_cmake $add2path;
      else
        read -p "Do you want install it? [y/n] " confirm;
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          get_cmake $add2path;
        fi
      fi
    fi
  fi
  # end cmake not found
}

install_cmake true -y
