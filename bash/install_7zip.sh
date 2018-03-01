#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function get_7zip
{
    if [[ "$OSTYPE" == "darwin"* ]]; then 
        url_7zip="https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2";
    else 
        url_7zip="https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2";
    fi

    add2path=$1
    echo "Download 7zip from " $url_7zip
    out_dir=$(echo $url | rev | cut -d'/' -f 1 | rev)
    out="$(basename $out_dir .tar.bz2)"
    wget $url_7zip

    echo "Unzip" $out_dir
    tar jxvf $out_dir

    $out=$(echo $out | cut -d'_' -f 1,2)
    cd $out/
    cp makefile.linux_gcc6_sanitize makefile.linux
    make -j all_test
    cd ..
    if $add2path; then  
        echo export PATH='$PATH':$PWD/$out/bin >> ~/.bashrc ; 
    fi
    export PATH=$PATH:$PWD/$out/bin 
}

function install_7zip
{
    add2path=$1
    confirm=$2

    if [ $(which 7za) == "" ]; then # not found
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
    fi
}
