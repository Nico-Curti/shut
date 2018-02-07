#!/bin/bash

function install_blender
{
	url=$1
	path=$2
	add2path=$3

	pushd $path

	echo "Download blender from " $url
	out_dir=$(echo $url | rev | cut -d'/' -f 1 | rev)
	out="$(basename $out_dir .tar.bz2)"
	ver=$(echo $out | cut -d'-' -f 2)
	wget $url

	echo "Unzip" $out_dir
	tar jxvf $out_dir
	rm -rf $out_dir
	mv $out blender
	if $add2path; then
		export PATH='$PATH':$PWD/blender/
		echo export PATH='$PATH':$PWD/blender/ >> ~/.bashrc
	fi

	url="https://bootstrap.pypa.io/get-pip.py"
	cd blender/$ver/python/bin
	echo Download get-pip from $url
	wget $url

	echo "Run get-pip"
	bpy=$(find -name "python*")
	bpy get-pip.py
	rm get-pip.py

	cd ../Scripts/
	for module in ${4:+"$@"}; do
		./pip install $module
	done

	popd
}

