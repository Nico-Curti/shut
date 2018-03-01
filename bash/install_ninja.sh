#!/bin/bash

function get_ninja
{
    add2path=$1
    ninja_version="1.8.2"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        url_ninja="https://github.com/ninja-build/ninja/releases/download/v$ninja_version/ninja-mac.zip"
    else
        url_ninja="https://github.com/ninja-build/ninja/releases/download/v$ninja_version/ninja-linux.zip"
    fi

    echo "Download ninja-build from " $url
    out_dir=$(echo $url_ninja | rev | cut -d'/' -f 1 | rev)
    out="$(basename $out_dir .zip)"
    wget $url_ninja

    echo "Unzip" $out_dir
    if [ -x "unizip" ]; then unzip $out_dir -d ninja; 
    else 7za x $out_dir -o ninja;
    fi
    rm -rf $out_dir
    if $add2path; then  echo export PATH='$PATH':$PWD/ninja >> ~/.bashrc; fi
    export PATH='$PATH':$PWD/ninja
}

function install_ninja
{
    add2path=$1
    confirm=$2

    printf "ninja-build identification: "
    if [ $(which ninja) != "" ];then 
        echo ${green}"FOUND"${reset};
    else
        if [ "$(python -c 'import sys;print(sys.version_info[0])')" -eq "3" ]; then # right python version installed
            Conda=$(which python)
            if echo $Conda | grep -q "miniconda" || echo $Conda | grep -q "anaconda"; then # CONDA INSTALLER FOUND
                if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then 
                    conda install -y -c anaconda ninja;
                else
                    read -p "Do you want install it? [y/n] " confirm
                    if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then 
                        echo ${red}"Abort"${reset};
                    else 
                        conda install -y -c anaconda ninja;
                    fi
                fi # end conda installer
            fi # end conda found
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
            fi # end function installer
        fi # end python found
    fi # end ninja not found
}
