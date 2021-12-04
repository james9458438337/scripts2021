#!/bin/bash

#Minimum dependencies to compile nginx tar ball : PCRE  ZIP  SSL

#install compile tools
yum group install -y "Development Tools"


#downlaod dependencies, Minimumd ependencies to compile nginx: PCRE  ZIP  SSL
mkdir -p /opt/install
cd /opt/install
#download   pcre openssl zlib  nginx tar ball
wget http://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz
tar -zxf pcre-8.45.tar.gz

wget --no-check-certificate http://www.openssl.org/source/openssl-1.0.2t.tar.gz
#wget --no-check-certificate http://www.openssl.org/source/openssl-1.1.1l.tar.gz
tar -zxf openssl-1.0.2t.tar.gz

wget http://zlib.net/zlib-1.2.11.tar.gz
tar -zxf zlib-1.2.11.tar.gz

wget http://nginx.org/download/nginx-1.19.3.tar.gz
tar -zxf nginx-1.19.3.tar.gz



#install nginx from source code

cd nginx-1.19.3
./configure --prefix=/usr/local/nginx  --with-openssl=/opt/install/openssl-1.0.2t --with-pcre=/opt/install/pcre-8.45 --with-zlib=/opt/install/zlib-1.2.11
make
make install

ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx


#start nginx
/usr/local/nginx/sbin/nginx