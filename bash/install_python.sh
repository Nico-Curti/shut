#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

function get_python
{
  add2path=$1
  #modules=$2

  if [[ "$OSTYPE" == "darwin"* ]]; then
    url_python="https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
  else
    url_python="https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"
  fi

  echo -e "${yellow}Download python from ${url_python}${reset}"
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

  printf "${yellow}Python3 identification: ${reset}"
  if [ -z $(which python) ]; then
    echo -e "${red}NOT FOUND${reset}"
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
      get_python true $modules
    else
      read -p "Do you want install it? [y/n] " confirm
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo -e "${red}Abort${reset}";
      else
        get_python true $modules
      fi
    fi
    # close python not found
  elif [ "$(python -c 'import sys;print(sys.version_info[0])')" -eq "3" ]; then # right python version installed
    echo -e "${green}FOUND${reset}"
    Conda=$(which python)
    printf "${yellow}Conda identification: ${reset}"
    if echo $Conda | grep -q "miniconda" || echo $Conda | grep -q "anaconda"; then
      # CONDA INSTALLER FOUND
      echo -e "${green}FOUND${reset}";
      for module in ${3:+"$@"}; do
        pip install $module
      done
    else
      echo -e "${red}NOT FOUND${reset}";
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_python true $modules
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo -e "${red}Abort${reset}";
        else
          get_python true $modules
        fi
      fi
      # close get python
    fi
  elif [ "$(python -c 'import sys;print(sys.version_info[0])')" -eq "2" ]; then
    echo -e "${red}The Python version found is too old${reset}";
    if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
      get_python true $modules
    else
      read -p "Do you want install it? [y/n] " confirm
      if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
        echo -e "${red}Abort${reset}";
      else
        get_python true $modules
      fi
    fi
    # close python too old
  else
    echo -e "${red}Python impossible to install${reset}"
  fi
}

#install_python true -y numpy scipy
