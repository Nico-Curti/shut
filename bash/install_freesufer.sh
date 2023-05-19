#!/bin/bash

red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
reset='\033[0m' # No Color

function get_freesurfer
{
    add2bashrc=$1
    version="7.4.0"
    here=$(pwd)

    if [[ "$OSTYPE" == "darwin"* ]]; then
        url_freesurfer="https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/$version/freesurfer-darwin-macOS-$version.tar.gz"
    else
        # TODO: up to now it will install only the Ubunt22 version, however specific versions for other distro are available
        # line Ubuntu20 and CentOS.
        url_freesurfer="https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/$version/freesurfer-linux-ubuntu22_amd64-$version.tar.gz"
    fi

    echo -e "${yellow}Download g++ from ${url_freesurfer}${reset}"
    out_dir=$(echo $url_freesurfer | rev | cut -d'/' -f 1 | rev)
    out="$(basename $out_dir .tar.gz)"
    echo "${here}/freesurfer"
    wget $url_freesurfer

    echo -e "${yellow} Untar ${out_dir}${reset}"
    tar -xzvf $out_dir

    # now add the freesurfer directiory to the path, and run the set up. 
    # if add2bashrc is True, this command will be add on your .bashrc file 
    # and runned each time you open the terninal. Otherwise they must be manually 
    # runned each time you need them
    if $add2bashrc; then
        echo "export FREESURFER_HOME=${here}/freesurfer" >> ~/.bashrc
        echo "source $FREESURFER_HOME/SetUpFreeSurfer.sh" >> ~/.bashrc
        source ~/.bashrc
    else 
        export FREESURFER_HOME=${here}/freesurfer
        source $FREESURFER_HOME/SetUpFreeSurfer.sh
    fi

}


function install_freesurfer
{
    add2bashrc=$1
    confirm=$2

    printf "${yellow} freesurfer identification: ${reset}"
    if [ ! z $(which freesurfer)]; then
        FRVER=$(recon-all -version | cut -d'v' -f 2 | cut -d'-' -f 1);
        echo -e "${green} FOUND Freesurfer v${FRVER}${reset}"
        
    else
        echo -e "${red}FREESURFER NOT FOUND${reset}"
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
            echo -e "${red}Abort${reset}";
        else
            get_freesurfer $add2bashrc
        fi
    fi
}

#install_freesurfer true -y