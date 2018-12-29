#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function get_7zip
{
  add2path=$1

  if [[ "$OSTYPE" == "darwin"* ]]; then
    url_7zip="https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2";
  else
    url_7zip="https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2";
  fi

  echo "Download 7zip from " $url_7zip
  out_dir=$(echo $url_7zip | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.bz2)"
  wget $url_7zip

  echo "Unzip" $out_dir
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

  printf "7zip identification: "
  if [ -z $(which 7za) ]; then # not found
    echo ${red}"NOT FOUND"${reset}
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ];then
      get_7zip $add2path;
    else
      read -p "Do you want install it? [y/n] " confirm
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo ${red}"Abort"${reset};
      else
        get_7zip $add2path
      fi
    fi
  else
    echo ${green}"FOUND"${reset}
  fi
}

#install_7zip true -y
