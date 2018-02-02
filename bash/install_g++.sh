#!/bin/bash

function install_g++
{
	url=$1
	path=$2
	add2path=$3

	pushd $path

	echo "Download .tar.gz from " $url
	out_dir=$(echo $url | rev | cut -d'/' -f 1 | rev)
	out="$(basename $out_dir .tar.gz)"
	wget $url

	echo "Unzip" $out_dir
	tar xzf $out_dir
	mv $out $out-sources
	cd $out-sources
	./contrib/download_prerequisites
	cd ..
	mkdir objdir
	cd objdir
	$PWD/../$out-sources/configure --prefix=$HOME/$out --enable-languages=c,c++
	make
	make install

	if $add2path; then
		export CC=$HOME/$out/bin/gcc
		export CXX=$HOME/$out/bin/g++
		echo "export CC=$HOME/$out/bin/gcc" >> ~/.bashrc
		echo "export CXX=$HOME/$out/bin/g++" >> ~/.bashrc
		export PATH=$PATH:$PWD/$out/bin/
		echo export PATH='$PATH':$PWD/$out/bin/ >> ~/.bashrc
	fi

	popd
}

