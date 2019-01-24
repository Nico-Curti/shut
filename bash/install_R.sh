#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

R_version="3.5.2"

function get_R
{
  add2path=$1
  postfix=$2
  modules=$3

  #if [[ "$OSTYPE" == "darwin"* ]]; then
  #  url_R="https://cran.r-project.org/bin/macosx/Mac-GUI-1.70.tar.gz"
  #else
  url_R="http://cran.rstudio.com/src/base/R-3/R-$R_version.tar.gz"
  #fi

  check=$(ldconfig -p | grep libzlib.so | cut -d' ' -f 1)
  printf "Zlib identification: "
  if [ $check != "libzlib.so1" ]; then
    echo ${red}"NOT FOUND"${reset}
    echo Download zlib library
    wget https://www.zlib.net/zlib-1.2.11.tar.gz
    tar xvf zlib-1.2.11.tar.gz
    mv zlib-1.2.11 zlib-1.2.11-sources
    cd zlib-1.2.11-sources
    ./configure --prefix=$HOME/toolchain/zlib-1.2.11
    make && make install
    cd ..
    rm -rf zlib-1.2.11.tar.gz
  else
    echo ${green}"FOUND"${reset}
  fi

  check=$(ldconfig -p | grep libbzip2.so | cut -d' ' -f 1)
  printf "LibBZIP2 identification: "
  if [ $check != "libbzip.so1" ]; then
    echo ${red}"NOT FOUND"${reset}
    echo Download bzip2 library
    wget distfiles.gentoo.org/distfiles/bzip2-1.0.6.tar.gz
    tar zxvf bzip2-1.0.6.tar.gz
    mv bzip2-1.0.6 bzip2-1.0.6-sources
    cd bzip2-1.0.6-sources
    make -f Makefile-libbz2_so
    make clean
    make CC="gcc -fPIC"
    make install CC="gcc -fPIC" PREFIX=$HOME/toolchain/bzip2-1.0.6
    cd ..
    rm -rf bzip2-1.0.6.tar.gz
  else
    echo ${green}"FOUND"${reset}
  fi

  check=$(ldconfig -p | grep libxz.so | cut -d' ' -f 1)
  printf "LibXZ identification: "
  if [ $check != "libxz5.so1" ]; then
    echo ${red}"NOT FOUND"${reset}
    echo Download xz library
    wget https://tukaani.org/xz/xz-5.2.4.tar.gz
    tar zxvf xz-5.2.4.tar.gz
    mv xz-5.2.4 xz-5.2.4-sources
    cd xz-5.2.4-sources
    ./configure --prefix=$HOME/toolchain/xz-5.2.4
    make && make install
    cd ..
    rm -rf xz-5.2.4.tar.gz
  else
    echo ${green}"FOUND"${reset}
  fi

  check=$(ldconfig -p | grep libpcre2.so | cut -d' ' -f 1)
  printf "LibPCRE2 identification: "
  if [ $check != "libpcre2.so1" ]; then
    echo ${red}"NOT FOUND"${reset}
    echo Download pcre library
    wget https://ftp.pcre.org/pub/pcre/pcre2-10.32.tar.gz
    tar zxvf pcre2-10.32.tar.gz
    mv pcre2-10.32 pcre2-10.32-sources
    cd pcre2-10.32-sources
    ./configure --prefix=$HOME/toolchain/pcre2-10.32 --enable-utf8
    make && make install
    cd ..
    rm -rf pcre2-10.32.tar.gz
  else
    echo ${green}"FOUND"${reset}
  fi

  check=$(ldconfig -p | grep libopenssl.so | cut -d' ' -f 1)
  printf "LibOPENSSL identification: "
  if [ $check != "libopenssl.so1" ]; then
    echo ${red}"NOT FOUND"${reset}
    echo Download OpenSSL library
    wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1.tar.gz
    tar zxvf openssl-1.1.1.tar.gz
    mv openssl-1.1.1 openssl-1.1.1-sources
    cd openssl-1.1.1-sources
    ./config --prefix=$HOME/toolchain/openssl-1.1.1
    make && make install
    cd ..
    rm -rf openssl-1.1.1.tar.gz
  else
    echo ${green}"FOUND"${reset}
  fi

  git clone https://github.com/nghttp2/nghttp2 nghttp2-sources
  cd nghttp2-sources
  mkdir buidl; cd build
  cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/toolchain/nghttp2/
  cmake --build . --target install

  # Troubles with libcurl http support!
  check=$(ldconfig -p | grep libcurl.so | cut -d' ' -f 1)
  printf "LibCURL identification: "
  if [ $check != "libcurl7.so1" ]; then
    echo ${red}"NOT FOUND"${reset}
    echo Download curl library
    wget https://curl.haxx.se/download/curl-7.63.0.tar.gz
    tar zxvf curl-7.63.0.tar.gz
    mv curl-7.63.0 curl-7.63.0-sources
    cd curl-7.63.0-sources
    ./configure --prefix=$HOME/toolchain/curl-7.63.0              \
               --with-ssl                                         \
               --with-libssl-prefix=$HOME/toolchain/openssl-1.1.1 \
               LDFLAGS="-L/$HOME/toolchain/nghttp2/lib"           \
               CPPFLAGS="-I/$HOME/toolchain/nghttp2/include"
    make && make install
    cd ..
    rm -rf curl-7.63.0.tar.gz
  else
    echo ${green}"FOUND"${reset}
  fi

  echo Download R from $url_R
  out_dir=$(echo $url_R | rev | cut -d'/' -f 1 | rev)
  out="$(basename $out_dir .tar.gz)"

  wget $url_R
  echo "Unzip" $out_dir
  tar zxf $out_dir
  mv $out $out-sources
  rm -rf $out_dir

  cd $out-sources
  ./configure --prefix=$HOME/$out                                  \
              --with-readline=no                                   \
              --with-x=no                                          \
               --enable-R-shlib                                    \
               LDFLAGS="-L/$HOME/toolchain/zlib-1.2.11/lib         \
                        -L/$HOME/toolchain/bzip2-1.0.6/lib         \
                        -L/$HOME/toolchain/xz-5.2.4/lib            \
                        -L/$HOME/toolchain/pcre2-10.32/lib         \
                        -L/$HOME/toolchain/curl-7.63.0/lib         \
                        -L/$HOME/toolchain/openssl-1.1.1/lib"      \
               CPPFLAGS="-I/$HOME/toolchain/zlib-1.2.11/include    \
                         -I/$HOME/toolchain/bzip2-1.0.6/include    \
                         -I/$HOME/toolchain/xz-5.2.4/include       \
                         -I/$HOME/toolchain/pcre2-10.32/include    \
                         -I/$HOME/toolchain/curl-7.63.0/include    \
                         -I/$HOME/toolchain/openssl-1.1.1/include"

  echo export LD_LIBRARY_PATH=$HOME/toolchain/pcre2-10.32/lib:'$LD_LIBRARY_PATH' >> ~/.bashrc
  echo export LD_LIBRARY_PATH=$HOME/toolchain/xz-5.2.4/lib:'$LD_LIBRARY_PATH'    >> ~/.bashrc
  source ~/.bashrc
  make && make install
  cd ..

  if $add2path; then
    if $postfix; then
      echo export PATH='$PATH':$HOME/$out/bin/ >> ~/.bashrc
    else
      echo export PATH=$HOME/$out/bin/:'$PATH' >> ~/.bashrc
    fi
  fi
  source ~/.bashrc
  #export PATH=$PATH:$PWD/$out/bin/
}

function install_R
{
  add2path=$1
  confirm=$2
  modules=$3
  postfix=$4

  printf "R identification: "
  if [ -z $(which r) ]; then
    echo ${red}"NOT FOUND"${reset}
    if [ $(which conda) ]; then
      echo "Installing R with Anaconda"
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        conda install -y -c r r
        conda install -y -c r r
        conda install -y -c r r-xml
        conda install -y -c r r-devtools
        conda install -y -c conda-forge libgit2
        conda install -y -c anaconda libxml2
        conda install -y -c r r-dplyr
        conda install -y -c r r-stringr
        conda install -y -c r r-httr
        conda install -y -c r r-ggplot2
        conda install -y -c r r-tidyverse
        conda install -y -c r r-rcpp
        conda install -y -c r r-ikernel

        for module in ${3:+"$@"}; do
          conda install -y $module
        done
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          conda install -y -c r r
          conda install -y -c r r
          conda install -y -c r r-xml
          conda install -y -c r r-devtools
          conda install -y -c conda-forge libgit2
          conda install -y -c anaconda libxml2
          conda install -y -c r r-dplyr
          conda install -y -c r r-stringr
          conda install -y -c r r-httr
          conda install -y -c r r-ggplot2
          conda install -y -c r r-tidyverse
          conda install -y -c r r-rcpp
          conda install -y -c r r-ikernel
          for module in ${3:+"$@"}; do
            conda install -y $module
          done
        fi
      fi
    else
      echo "Installing R from source"
      if [ "$confirm" == "-y" ] || [ "$confirm" == "-Y" ] || [ "$confirm" == "yes" ]; then
        get_R true $postfix
      else
        read -p "Do you want install it? [y/n] " confirm
        if [ "$confirm" == "n" ] || [ "$confirm" == "N" ]; then
          echo ${red}"Abort"${reset};
        else
          get_R true $postfix $modules
        fi
      fi
    # end anaconda
    fi
  else
    echo ${green}"FOUND"${reset}
  fi
}

#install_R true -y
