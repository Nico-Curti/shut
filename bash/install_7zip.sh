
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


	cd p7zip_16.02/ # wrong
	cp makefile.linux_gcc6_sanitize makefile.linux # wrong
	make -j all_test
	cd ..
	if $add2path; then
		export PATH=$PATH:$PWD/p7zip_16.02/bin # wrong
		echo export PATH='$PATH':$PWD/p7zip_16.02/bin >> ~/.bashrc # wrong
	fi

	popd
}
