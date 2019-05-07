#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

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

  echo "Download julia from " $url_julia
  out_dir=$(echo $url_julia | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.gz)"
  wget $url_julia

  echo "Unzip" $out_dir
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

  printf "julia identification: "
  if [ -z $(which julia) ]; then # not found
    echo ${red}"NOT FOUND"${reset}
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ];then
      get_julia $add2path;
    else
      read -p "Do you want install it? [y/n] " confirm
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo ${red}"Abort"${reset};
      else
        get_julia $add2path
      fi
    fi
  else
    echo ${green}"FOUND"${reset}
  fi
}

#install_julia true -y
