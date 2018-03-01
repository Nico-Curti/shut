#!/bin/bash

function get_pip
{
    url_pip="https://bootstrap.pypa.io/get-pip.py"
    echo Download get-pip from $url_pip
    wget $url_pip

    echo "Run get-pip"
    if [ $(which python) ]; then python pwd/get-pip.py;
    else echo python NOT FOUND; fi    
}
