#!/bin/bash

#Install opensl
wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1l.tar.gz
tar xvfz openssl-1.1.1c.tar.gz
cd openssl-1.1.1l
./config --prefix=/usr/local/openssl/1_1_1l --openssldir=/usr/local/openssl shared
make
make install

<< COMMENT
--prefix:

The top of the installation directory tree.

shared

Build shared libraries are named libcrypto.so.X.X.

darwin64-x86_64-cc

Build as 64bit library. (Used on Mac OS)

--openssldir

Directory for OpenSSL files. If no prefix is specified, the library files and binaries are also installed there.
COMMENT

#Create installed libraries to under "/usr/local" by symbolic link.
# /usr/local/bin
ln -s /usr/local/openssl/1_1_1l/bin/c_rehash /usr/local/bin/
ln -s /usr/local/openssl/1_1_1l/bin/openssl /usr/local/bin/

#/usr/local/include
ln -s /usr/local/openssl/1_1_1l/include/openssl /usr/local/include/

#/usr/local/lib
ln -s /usr/local/openssl/1_1_1l/lib/engines-1.1 /usr/local/lib/
ln -s /usr/local/openssl/1_1_1l/lib/libcrypto.a /usr/local/lib/ 
ln -s /usr/local/openssl/1_1_1l/lib/libcrypto.so /usr/local/lib/
ln -s /usr/local/openssl/1_1_1l/lib/libcrypto.so.1.0.0 /usr/local/lib/
ln -s /usr/local/openssl/1_1_1l/lib/libssl.a /usr/local/lib/
ln -s /usr/local/openssl/1_1_1l/lib/libssl.so /usr/local/lib/
ln -s /usr/local/openssl/1_1_1l/lib/libssl.so.1.0.0 /usr/local/lib/

#/usr/local/lib/pkgconfig
ln -s /usr/local/openssl/1_1_1l/lib/pkgconfig/libcrypto.pc /usr/local/lib/pkgconfig/
ln -s /usr/local/openssl/1_1_1l/lib/pkgconfig/libssl.pc /usr/local/lib/pkgconfig/
ln -s /usr/local/openssl/1_1_1l/lib/pkgconfig/openssl.pc /usr/local/lib/pkgconfig/

cat << EOF >> ~/.bash_profile
# OpenSSL
OPENSSL_INC=/usr/local/include/openssl
OPENSSL_ENGINE_LIB=/usr/local/lib/engines-1.1

export CPATH=$OPENSSL_INC:$CPATH
export LD_LIBRARY_PATH=/usr/local/lib:$OPENSSL_ENGINE_LIB:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
EOF

#load shared libraries in the system, create a file which is wrote "/usr/local/lib" under /etc/ld.so.conf.d.
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
ldconfig -v

#mv /bin/openssl /bin/openssl1.0.2
#ln -s /usr/local/openssl/1_1_1l/bin/openssl /bin/openssl