#!/bin/bash

function install_pip
{
	url="https://bootstrap.pypa.io/get-pip.py"
	echo Download get-pip from $url
	wget $url

	echo "Run get-pip"
    if [ $(which python) ]; then python pwd/get-pip.py;
	else echo python NOT FOUND; fi    
}
