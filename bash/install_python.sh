#!/bin/bash

function get_python
{
    add2path=$1
    modules=$2

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
    bash $Exec -b
    conda update conda -y
    conda config --add channels bioconda

    for module in ${2:+"$@"}; do
        pip install $module
    done

    if $add2path; then  echo export PATH=~/$Conda/bin:~/$Conda/Scripts:~/$Conda/Library/bin:~/$Conda/Library/usr/bin:~/$Conda/Library/mingw-w64/bin:'$PATH' >> ~/.bashrc; fi
    export PATH=~/$Conda/bin:~/$Conda/Scripts:~/$Conda/Library/bin:~/$Conda/Library/usr/bin:~/$Conda/Library/mingw-w64/bin:'$PATH'
    rm $Exec
}

function install_python
{
    add2path=$1
    confirm=$2
    modules=$3

    printf "Python3 identification: "
    if [ "$(python -c 'import sys;print(sys.version_info[0])')" -eq "3" ]; then # right python version installed
        echo ${green}"FOUND"${reset}
        Conda=$(which python)
        printf "Conda identification: "
        if echo $Conda | grep -q "miniconda" || echo $Conda | grep -q "anaconda"; then 
            echo ${green}"FOUND"${reset}; # CONDA INSTALLER FOUND
        else
            echo ${red}"NOT FOUND"${reset};
            if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then 
                get_python true seaborn pandas ipython numpy matplotlib snakemake graphviz spyder sklearn;
            else
                read -p "Do you want install it? [y/n] " confirm
                if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then 
                    echo ${red}"Abort"${reset};
                else 
                    get_python true seaborn pandas ipython numpy matplotlib snakemake graphviz spyder sklearn;
                fi
            fi # close get python
        fi
    elif [ "$(python -c 'import sys;print(sys.version_info[0])')" -eq "2" ]; then   
        echo ${red}"The Python version found is too new modules"${reset};
        if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then 
            get_python true seaborn pandas ipython numpy matplotlib snakemake graphviz spyder sklearn;
        else
            read -p "Do you want install it? [y/n] " confirm
            if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then 
                echo ${red}"Abort"${reset};
            else 
                get_python true seaborn pandas ipython numpy matplotlib snakemake graphviz spyder sklearn;
            fi
        fi # close python too old
    else
        echo ${red}"NOT FOUND"
        if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then 
            get_python true seaborn pandas ipython numpy matplotlib snakemake graphviz spyder sklearn;
        else
            read -p "Do you want install it? [y/n] " confirm
            if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then 
                echo ${red}"Abort"${reset};
            else 
                get_python true seaborn pandas ipython numpy matplotlib snakemake graphviz spyder sklearn;
            fi
        fi # close python not found
    fi
}
