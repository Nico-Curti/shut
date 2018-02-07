#!/bin/bash

function install_7zip
{
	url=$1
	path=$2
	add2path=$3

	pushd $path

	echo "Download 7zip from " $url
	out_dir=$(echo $url | rev | cut -d'/' -f 1 | rev)
	out="$(basename $out_dir .tar.bz2)"
	wget $url

	echo "Unzip" $out_dir
	tar jxvf $out_dir

	$out=$(echo $out | cut -d'_' -f 1,2)
	cd $out/
	cp makefile.linux_gcc6_sanitize makefile.linux
	make -j all_test
	cd ..
	if $add2path; then	echo export PATH='$PATH':$PWD/$out/bin >> ~/.bashrc ; fi
	export PATH=$PATH:$PWD/$out/bin 

	popd
}
