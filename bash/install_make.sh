#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function get_make
{
  add2path=$1

  if [[ "$OSTYPE" == "darwin"* ]]; then
      url_make=""
  else
      url_make=""
  fi

  echo "Download make from " $url_make
  out_dir=$(echo $url_make | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.gz)"
  wget $url_make

  echo "Unzip" $out_dir
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

  printf "make identification: "
  if [ -z $(which make) ]; then
    # NO make
    echo ${red}"NOT FOUND"${reset}
    if [ ! -z $(which conda) ]; then
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        conda install -y -c anaconda make
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          conda install -y -c anaconda make
        fi
      fi
    else
      echo ${red}"make available only with conda"${reset}
      #exit 1
    fi
  else
    echo ${green}"FOUND"${reset};
  fi
}

#install_make true -y
