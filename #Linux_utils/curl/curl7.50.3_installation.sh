#!/bin/bash

#uninstall
rm -f /usr/local/bin/curl7503
rm -f /usr/local/bin/curl7503-config 
rm -f /usr/local/include/curl
rm -f /usr/local/lib/libcurl*
rm -f /usr/local/lib/pkgconfig/libcurl.pc
rm -f /usr/local/share/aclocal/libcurl.m4

#Install openssl1.1.1 first
wget --no-check-certificate https://curl.haxx.se/download/curl-7.50.3.tar.gz
tar xvfz curl-7.50.3.tar.gz
cd curl-7.50.3
./configure --prefix=/usr/local/curl/7_50_3 --with-ssl=/usr/local/openssl/1_1_1l
make
make install

#Create installed libraries to under "/usr/local" by symbolic link.
#/usr/local/bin
ln -s /usr/local/curl/7_50_3/bin/curl /usr/local/bin/curl7503
ln -s /usr/local/curl/7_50_3/bin/curl-config /usr/local/bin/curl7503-config 

#/usr/local/include
ln -s //usr/local/curl/7_50_3/include/curl /usr/local/include/

#/usr/local/lib
ln -s /usr/local/curl/7_50_3/lib/libcurl.a /usr/local/lib/
ln -s /usr/local/curl/7_50_3/lib/libcurl.la /usr/local/lib/
ln -s /usr/local/curl/7_50_3/lib/libcurl.so /usr/local/lib/
ln -s /usr/local/curl/7_50_3/lib/libcurl.so.4 /usr/local/lib/
ln -s /usr/local/curl/7_50_3/lib/libcurl.so.4.4.0 /usr/local/lib/

#/usr/local/lib/pkgconfig
ln -s /usr/local/curl/7_50_3/lib/pkgconfig/libcurl.pc /usr/local/lib/pkgconfig/

#/usr/local/share/aclocal
ln -s /usr/local/curl/7_50_3/share/aclocal/libcurl.m4 /usr/local/share/aclocal/



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