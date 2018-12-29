#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function get_pip
{
  if [ -z $(which python) ]; then
    echo ${red}python NOT FOUND${reset}
  else
    url_pip="https://bootstrap.pypa.io/get-pip.py"
    echo Download get-pip from $url_pip
    wget $url_pip

    echo "Run get-pip"
    python $PWD/get-pip.py
  fi
}

get_pip
