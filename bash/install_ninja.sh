#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function get_ninja
{
  add2path=$1
  version="1.8.2"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    url_ninja="https://github.com/ninja-build/ninja/releases/download/v$version/ninja-mac.zip"
  else
    url_ninja="https://github.com/ninja-build/ninja/releases/download/v$version/ninja-linux.zip"
  fi

  echo "Download ninja-build from " $url
  name=$(echo $url_ninja | rev | cut -d'/' -f 1 | rev)
  out="$(basename $name .zip)"
  wget $url_ninja

  mkdir -p ninja
  mv $name ninja/
  cd ninja

  echo "Unzip" $name
  if [ -x "unzip" ]; then
    unzip $name;
  else
    7za x $name;
  fi
  rm -rf $name
  cd ..

  if $add2path; then
    echo export PATH='$PATH':$PWD/ninja >> ~/.bashrc;
  fi
  #export PATH='$PATH':$PWD/ninja
}

function install_ninja
{
  add2path=$1
  confirm=$2

  printf "ninja-build identification: "
  if [ ! -z $(which ninja) ]; then
    echo ${green}"FOUND"${reset}
  else
    echo ${red}"NOT FOUND"${reset}
    if [ ! -z $(which conda) ]; then
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        conda install -y -c anaconda ninja;
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          conda install -y -c anaconda ninja;
        fi
      fi
    else
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_ninja $add2path;
      else
        read -p "Do you want install it? [y/n] " confirm;
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          get_ninja $add2path;
        fi
      fi
      # end function installer
    fi
    # end python found
  fi
  # end ninja not found
}

#install_ninja true -y
