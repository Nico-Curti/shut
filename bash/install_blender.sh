#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function get_blender
{
    add2path=$1
    modules=$2

    if [[ "$OSTYPE" == "darwin"* ]]; then
        url_blender="https://ftp.halifax.rwth-aachen.de/blender/release/Blender2.79/blender-2.79-macOS-10.6.tar.gz"
    else
        url_blender="https://ftp.halifax.rwth-aachen.de/blender/release/Blender2.79/blender-2.79-linux-glibc219-x86_64.tar.bz2"
    fi

    echo "Download blender from " $url_blender
    out_dir=$(echo $url | rev | cut -d'/' -f 1 | rev)
    out="$(basename $out_dir .tar.bz2)"
    ver=$(echo $out | cut -d'-' -f 2)
    wget $url_blender

    echo "Unzip" $out_dir
    if [[ "$OSTYPE" == "darwin"* ]]; then
        tar xzf $out_dir
    else
        tar jxvf $out_dir
    fi
    rm -rf $out_dir
    mv $out blender
    if $add2path; then  echo export PATH='$PATH':$PWD/blender/ >> ~/.bashrc ; fi
    export PATH='$PATH':$PWD/blender/

    url_pip="https://bootstrap.pypa.io/get-pip.py"
    cd blender/$ver/python/bin
    echo Download get-pip from $url_pip
    wget $url_pip

    echo "Run get-pip"
    bpy=$(find -name "python*")
    bpy get-pip.py
    rm get-pip.py

    cd ../Scripts/
    for module in ${2:+"$@"}; do
        ./pip install $module
    done
}

function install_blender
{
    add2path=$1
    confirm=$2
    modules=$3

    printf "Blender identification: "
    if [ $(which blender) == "" ]; then
        echo ${red}"NOT FOUND"${reset}
        if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then 
            get_blender $add2path $modules;
        else
            read -p "Do you want install it? [y/n] " confirm
            if [ "$CONFIRM" == "n" ] || [ "$CONFIRM" == "N" ]; then 
                echo ${red}"Abort"${reset};
            else 
                get_blender $add2path $modules;
            fi
        fi
    else 
        echo ${green}"FOUND"${reset};
    fi
}

