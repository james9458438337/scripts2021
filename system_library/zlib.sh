#!/bin/bash

#downlod and compile 
cd /tmp
wget https://www.zlib.net/zlib-1.2.11.tar.gz
tar xvfz zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure --prefix=/usr/local/zlib/1_2_11
make
make install

#Create Symbolic Link

#// /usr/local/include
ln -s /usr/local/zlib/1_2_11/include/zconf.h /usr/local/include/
ln -s /usr/local/zlib/1_2_11/include/zlib.h /usr/local/include/

#// /usr/local/lib
ln -s /usr/local/zlib/1_2_11/lib/libz.a /usr/local/lib/
ln -s /usr/local/zlib/1_2_11/lib/libz.so /usr/local/lib/
ln -s /usr/local/zlib/1_2_11/lib/libz.so.1 /usr/local/lib/
ln -s /usr/local/zlib/1_2_11/lib/libz.so.1.2.11 /usr/local/lib/

#// /usr/local/lib/pkgconfig
ln -s /usr/local/zlib/1_2_11/lib/pkgconfig/zlib.pc /usr/local/lib/pkgconfig/

#Set Environment Variable
cat << EOF >> ~/.bash_profile
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
EOF

# load shared libraries in the system
echo "/usr/local/zlib/1_2_11/lib" >> /etc/ld.so.conf.d/extend.conf
ldconfig && ldconfig -p | grep zlib
pkg-config zlib --libs --cflags

