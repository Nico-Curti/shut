#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

version="9.2.0"

function get_g++
{
  add2path=$1
  postfix=$2

  if [[ "$OSTYPE" == "darwin"* ]]; then
    url_gcc="ftp://ftp.gnu.org/gnu/gcc/gcc-$version/gcc-$version.tar.gz"
  else
    url_gcc="ftp://ftp.gnu.org/gnu/gcc/gcc-$version/gcc-$version.tar.gz"
  fi

  echo -e "${yellow}Download g++ from ${url_gcc}${reset}"
  out_dir=$(echo $url_gcc | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.gz)"
  wget $url_gcc

  echo -e "${yellow}Unzip ${out_dir}${reset}"
  tar xzf $out_dir
  mv $out $out-sources
  cd $out-sources
  ./contrib/download_prerequisites
  cd ..
  mkdir -p objdir
  cd objdir
  $PWD/../$out-sources/configure --prefix=$HOME/$out --enable-languages=c,c++ || $PWD/../$out-sources/configure --prefix=$HOME/$out --enable-languages=c,c++ --disable-multilib
  make
  make install
  cd ..

  if $add2path; then
    echo "export CC=$HOME/$out/bin/gcc" >> ~/.bashrc
    echo "export CXX=$HOME/$out/bin/g++" >> ~/.bashrc
    if $postfix; then
      echo export PATH='$PATH':$HOME/$out/bin/ >> ~/.bashrc
    else
      echo export PATH=$HOME/$out/bin/:'$PATH' >> ~/.bashrc
    fi
  fi
  #export CC=$HOME/$out/bin/gcc
  #export CXX=$HOME/$out/bin/g++
  #export PATH=$PATH:$PWD/$out/bin/
}

function install_g++
{
  add2path=$1
  confirm=$2
  postfix=$3

  printf "${yellow}g++ identification: ${reset}"
  if [ ! -z $(which g++) ]; then
    # found a version of g++
    GCCVER=$(g++ --version | cut -d' ' -f 3);
    GCCVER=$(echo $GCCVER | cut -d' ' -f 1 | cut -d'.' -f 1);
  fi
  if [ -z $(which g++) ]; then
    echo -e "${red}NOT FOUND{reset}"
    # NO g++
    if [ ! -z $(which conda) ]; then
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        conda install -y -c conda-forge isl=0.17.1
        conda install -y -c creditx gcc-7
        conda install -y -c gouarin libgcc-7
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
          conda install -y -c conda-forge isl=0.17.1
          conda install -y -c creditx gcc-7
          conda install -y -c gouarin libgcc-7
        fi
      fi
    else
      echo -e "${red}g++ available only with conda${reset}"
      exit 1
    fi
    # end conda installer
  elif [[ "$GCCVER" -lt "5" ]]; then
    # check version of g++
    echo -e "${red}sufficient version NOT FOUND${reset}"
    if [ $(which make) != "" ]; then
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_g++ $add2path $postfix
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
          get_g++ $add2path $postfix
        fi
      fi
    else
      echo -e "${red}g++ installation without conda available only with make installed${reset}"
      exit 1
    fi
  else
    echo -e "${green}FOUND${reset}";
    ver=$(echo $(g++ --version) | cut -d' ' -f 4)
    ver=$(echo "${ver//./}")
    currver=$(echo "${version//./}")
    if [ $ver -lt $currver ]; then
      echo -e "${red}Old g++ version found${reset}"
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_g++ $add2path $postfix
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
          get_g++ $add2path $postfix
        fi
      fi
    fi
  fi
}

#install_g++ true -y
