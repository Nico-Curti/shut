#!/bin/bash
# url="https://dl.influxdata.com/telegraf/releases/telegraf-1.5.2_linux_amd64.tar.gz"

function install_telegraf
{
    url=$1
    path=$2
    add2path=$3

    pushd $path

    echo "Download telegraf from " $url
    out_dir=$(echo $url | rev | cut -d'/' -f 1 | rev)
    out="$(basename $out_dir .tar.gz)"
    wget $url

    echo "Unzip" $out_dir
    tar zxf $out_dir
    rm -rf $out_dir
    if $add2path; then  echo export PATH='$PATH':$PWD/telegraf/usr/bin >> ~/.bashrc ; fi
    export PATH='$PATH':$PWD/telegraf/usr/bin
    popd
}
