#!/bin/bash

# $1 = -y
# $2 = installation path from root
# $3 = silent mode (true/false)

confirm=$1
if [ "$2" == "" ]; then
  path2out="toolchain"
else
  path2out=$2
fi
silent=$3

source ~/.bashrc

project="shut"
log="install_$project.log"

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

gcc_min_version="7.3.0"
cmake_min_version="3.12.1"

echo ${yellow}"Installing $project dependecies:"${reset}
echo "  - (Conda) Python3"
source ./bash/install_python.sh
echo "  - g++ (> $gcc_min_version)"
source ./bash/install_g++.sh
echo "  - make"
source ./bash/install_make.sh
echo "  - cmake (> $cmake_min_version)"
source ./bash/install_cmake.sh
echo "  - ninja-build"
source ./bash/install_7zip.sh
source ./bash/install_ninja.sh


echo "Installation path : "${green}$path2out${reset}

pushd $HOME > /dev/null
mkdir -p $path2out
cd $path2out

echo "Looking for packages..."
# clean old log file
rm -f $log

echo "Installing Python3"
if [ $silent ]; then
  install_python true $confirm >> $log
else
  install_python true $confirm
fi
source ~/.bashrc

echo "Installing g++"
if [ $silent ]; then
  install_g++ true $confirm true >> $log
else
  install_g++ true $confirm true
fi
source ~/.bashrc
if [ ! -z $(which g++) ]; then
  gcc_ver=$(echo $(g++ --version) | cut -d' ' -f 4)
  gcc_ver=$(echo "${gcc_ver//./}")
  gcc_min_version=$(echo "${gcc_min_version//./}")
  if [ $gcc_ver -lt $gcc_min_version ]; then
    if [ $silent ]; then
      install_g++ true $confirm false >> $log
    else
      install_g++ true $confirm false
    fi
  fi
  source ~/.bashrc
fi

echo "Installing Make"
if [ $silent ]; then
  install_make true $confirm >> $log
else
  install_make true $confirm
fi
source ~/.bashrc

echo "Installing CMake"
if [ $silent ]; then
  install_cmake true $confirm true >> $log
else
  install_cmake true $confirm true
fi
source ~/.bashrc
if [ ! -z $(which cmake) ]; then
  cmake_ver=$(echo $(cmake --version) | cut -d' ' -f 3)
  cmake_ver=$(echo "${cmake_ver//./}")
  cmake_min_version=$(echo "${cmake_min_version//./}")
  if [ $cmake_ver -lt $cmake_min_version ]; then
    if [ $silent ]; then
      install_cmake true $confirm false >> $log
    else
      install_cmake true $confirm false
    fi
  fi
  source ~/.bashrc
fi

echo "Installing 7zip"
if [ $silent ]; then
  install_7zip true $confirm >> $log
else
  install_7zip true $confirm
fi
source ~/.bashrc

echo "Installing ninja-build"
if [ $silent ]; then
  install_ninja true $confirm >> $log
else
  install_ninja true $confirm
fi
source ~/.bashrc

popd > /dev/null

# Build project
#echo ${yellow}"Build $project"${reset}
#if [ $silent ]; then
#  sh ./build.sh >> $log
#else
#  sh ./build.sh
#fi
