#!/bin/bash

function install_python
{
	url=$1
	add2path=$2

	echo Download python from $url
	Exec=$(echo $url | rev | cut -d'/' -f 1 | rev)
	Conda=$(echo $Exec | cut -d'-' -f 1)

	wget $url
	chmod ugo+x $Exec
	bash $Exec -b
	conda update conda -y
	conda config --add channels bioconda

	for module in ${3:+"$@"}; do
		pip install $module
	done

	if $add2path; then	echo export PATH=~/$Conda/bin:~/$Conda/Scripts:~/$Conda/Library/bin:~/$Conda/Library/usr/bin:~/$Conda/Library/mingw-w64/bin:'$PATH' >> ~/.bashrc; fi
	export PATH=~/$Conda/bin:~/$Conda/Scripts:~/$Conda/Library/bin:~/$Conda/Library/usr/bin:~/$Conda/Library/mingw-w64/bin:'$PATH'
	rm $Exec
}

