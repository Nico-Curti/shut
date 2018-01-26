
function install_cmake()
{
	url=$1
	path=$2
	add2path=$3

	pushd $path

	echo "Download CMAKE from " $url
	out_dir=$(echo $url | rev | cut -d'/' -f 1 | rev)
	out="$(basename $out_dir .tar.gz)"
	wget $url

	echo "Unzip" $out_dir
	tar zxf $out_dir
	rm -rf $out_dir
	mv $out cmake
	if $add2path; then
		export PATH='$PATH':$PWD/cmake/bin
		echo export PATH='$PATH':$PWD/cmake/bin >> ~/.bashrc
	fi

	popd
}

install_cmake "https://cmake.org/files/v3.10/cmake-3.10.0-Linux-x86_64.tar.gz" "." true
