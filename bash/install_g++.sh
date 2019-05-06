#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

version="8.2.0"

function get_g++
{
  add2path=$1
  postfix=$2

  if [[ "$OSTYPE" == "darwin"* ]]; then
    url_gcc="ftp://ftp.gnu.org/gnu/gcc/gcc-$version/gcc-$version.tar.gz"
  else
    url_gcc="ftp://ftp.gnu.org/gnu/gcc/gcc-$version/gcc-$version.tar.gz"
  fi

  echo "Download g++ from " $url_gcc
  out_dir=$(echo $url_gcc | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.gz)"
  wget $url_gcc

  echo "Unzip" $out_dir
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

  printf "g++ identification: "
  if [ ! -z $(which g++) ]; then
    # found a version of g++
    GCCVER=$(g++ --version | cut -d' ' -f 3);
    GCCVER=$(echo $GCCVER | cut -d' ' -f 1 | cut -d'.' -f 1);
  fi
  if [ -z $(which g++) ]; then
    echo ${red}"NOT FOUND"{reset}
    # NO g++
    if [ ! -z $(which conda) ]; then
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        conda install -y -c conda-forge isl=0.17.1
        conda install -y -c creditx gcc-7
        conda install -y -c gouarin libgcc-7
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          conda install -y -c conda-forge isl=0.17.1
          conda install -y -c creditx gcc-7
          conda install -y -c gouarin libgcc-7
        fi
      fi
    else
      echo ${red}"g++ available only with conda"${reset}
      exit 1
    fi
    # end conda installer
  elif [[ "$GCCVER" -lt "5" ]]; then
    # check version of g++
    echo ${red}sufficient version NOT FOUND${reset}
    if [ $(which make) != "" ]; then
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_g++ $add2path $postfix
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          get_g++ $add2path $postfix
        fi
      fi
    else
      echo ${red}"g++ installation without conda available only with make installed"${reset}
      exit 1
    fi
  else
    echo ${green}"FOUND"${reset};
    ver=$(echo $(g++ --version) | cut -d' ' -f 4)
    ver=$(echo "${ver//./}")
    currver=$(echo "${version//./}")
    if [ $ver -lt $currver ]; then
      echo ${red}"Old g++ version found"${reset}
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_g++ $add2path $postfix
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          get_g++ $add2path $postfix
        fi
      fi
    fi
  fi
}

#install_g++ true -y
