#!/bin/bash

function install_ninja
{
	url=$1
	path=$2
	add2path=$3

	pushd $path

	echo "Download ninja-build from " $url
	out_dir=$(echo $url | rev | cut -d'/' -f 1 | rev)
	out="$(basename $out_dir .zip)"
	wget $url

	echo "Unzip" $out_dir
	if [ -x "unizip" ]; then unzip $out_dir -d ninja; 
	else 7za x $out_dir -o ninja;
	fi
	rm -rf $out_dir
	if $add2path; then
		export PATH='$PATH':$PWD/ninja
		echo export PATH='$PATH':$PWD/ninja >> ~/.bashrc
	fi

	popd
}

install_ninja "https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip" "." true

