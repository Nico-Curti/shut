#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function get_telegraf
{
  add2path=$1
  version="1.5.2"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    url_telegraf=""
    echo "SOURCE CODE NOT AVAILABLE"
    exit 1
  else
    url_telegraf="https://dl.influxdata.com/telegraf/releases/telegraf-$version"
    url_telegraf+="_linux_amd64.tar.gz"
  fi

  echo "Download telegraf from " $url_telegraf
  out_dir=$(echo $url_telegraf | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.gz)"
  wget $url_telegraf

  echo "Unzip" $out_dir
  tar zxf $out_dir
  rm -rf $out_dir
  if $add2path; then
    echo export PATH='$PATH':$PWD/telegraf/usr/bin >> ~/.bashrc
  fi
  #export PATH='$PATH':$PWD/telegraf/usr/bin
}

function install_telegraf
{
  add2path=$1
  confirm=$2

  printf "telegraf identification: "
  if [ -z $(which telegraf) ];then
    echo ${red}"NOT FOUND"${reset}
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
      get_telegraf $add2path;
    else
      read -p "Do you want install it? [y/n] " confirm;
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo ${red}"Abort"${reset};
      else
        get_telegraf $add2path;
      fi
    fi
    # end function installer
  else
    echo ${green}"FOUND"${reset};
  fi
}

#install_telegraf true -y
