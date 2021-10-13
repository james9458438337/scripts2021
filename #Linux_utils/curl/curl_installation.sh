#!/bin/bash


wget --no-check-certificate https://curl.haxx.se/download/curl-7.65.3.tar.gz
tar xvfz curl-7.65.3.tar.gz
cd curl-7.65.3
./configure --prefix=/usr/local/curl/7_65_3
make
make install

#Create installed libraries to under "/usr/local" by symbolic link.
#/usr/local/bin
ln -s /usr/local/curl/7_65_3/bin/curl /usr/local/bin/
ln -s /usr/local/curl/7_65_3/bin/curl-config /usr/local/bin/

#/usr/local/include
ln -s //usr/local/curl/7_65_3/include/curl /usr/local/include/

#/usr/local/lib
ln -s /usr/local/curl/7_65_3/lib/libcurl.a /usr/local/lib/
ln -s /usr/local/curl/7_65_3/lib/libcurl.la /usr/local/lib/
ln -s /usr/local/curl/7_65_3/lib/libcurl.so /usr/local/lib/
ln -s /usr/local/curl/7_65_3/lib/libcurl.so.4 /usr/local/lib/
ln -s /usr/local/curl/7_65_3/lib/libcurl.so.4.5.0 /usr/local/lib/

#/usr/local/lib/pkgconfig
ln -s /usr/local/curl/7_65_3/lib/pkgconfig/libcurl.pc /usr/local/lib/pkgconfig/

#/usr/local/share/aclocal
ln -s /usr/local/curl/7_65_3/share/aclocal/libcurl.m4 /usr/local/share/aclocal/



#Set Environment Variable

cat << EOF >> ~/.bash_profile
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export ACLOCAL_PATH=/usr/local/share/aclocal/:$ACLOCAL_PATH
EOF

#load shared libraries in the system, create a file which is wrote "/usr/local/lib" under /etc/ld.so.conf.d.
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
ldconfig -v