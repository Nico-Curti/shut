#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function get_python
{
  add2path=$1
  #modules=$2

  if [[ "$OSTYPE" == "darwin"* ]]; then
    url_python="https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
  else
    url_python="https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"
  fi

  echo Download python from $url_python
  Exec=$(echo $url_python | rev | cut -d'/' -f 1 | rev)
  Conda=$(echo $Exec | cut -d'-' -f 1)

  wget $url_python
  chmod ugo+x $Exec
  bash $Exec -b -p $PWD/$Conda
  if $add2path; then
    echo export PATH=$PWD/$Conda/bin:$PWD/$Conda/Scripts:$PWD/$Conda/Library/bin:$PWD/$Conda/Library/usr/bin:$PWD/$Conda/Library/mingw-w64/bin:'$PATH' >> ~/.bashrc
  fi
  #export PATH=$PWD/$Conda/bin:$PWD/$Conda/Scripts:$PWD/$Conda/Library/bin:$PWD/$Conda/Library/usr/bin:$PWD/$Conda/Library/mingw-w64/bin:'$PATH'
  source ~/.bashrc

  conda update conda -y
  conda config --add channels bioconda

  for module in "${@:2}"; do
    pip install $module
  done

  rm $Exec
}

function install_python
{
  add2path=$1
  confirm=$2
  modules=$3

  printf "Python3 identification: "
  if [ -z $(which python) ]; then
    echo ${red}"NOT FOUND"${reset}
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
      get_python true $modules
    else
      read -p "Do you want install it? [y/n] " confirm
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo ${red}"Abort"${reset};
      else
        get_python true $modules
      fi
    fi
    # close python not found
  elif [ "$(python -c 'import sys;print(sys.version_info[0])')" -eq "3" ]; then # right python version installed
    echo ${green}"FOUND"${reset}
    Conda=$(which python)
    printf "Conda identification: "
    if echo $Conda | grep -q "miniconda" || echo $Conda | grep -q "anaconda"; then
      # CONDA INSTALLER FOUND
      echo ${green}"FOUND"${reset};
      for module in ${3:+"$@"}; do
        pip install $module
      done
    else
      echo ${red}"NOT FOUND"${reset};
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_python true $modules
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          get_python true $modules
        fi
      fi
      # close get python
    fi
  elif [ "$(python -c 'import sys;print(sys.version_info[0])')" -eq "2" ]; then
    echo ${red}"The Python version found is too old"${reset};
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
      get_python true $modules
    else
      read -p "Do you want install it? [y/n] " confirm
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo ${red}"Abort"${reset};
      else
        get_python true $modules
      fi
    fi
    # close python too old
  else
    echo ${red}"Python impossible to install"${reset}
  fi
}

#install_python true -y numpy scipy
