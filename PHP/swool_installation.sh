#!/bin/bash

yum -y install epel-release
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum install -y autoconf php72w-devel glibc-headers gcc-c++ git

#solution1 pecl install swool
#pecl install swoole
#pecl install --configureoptions 'enable-sockets="no" enable-openssl="yes" enable-http2="yes" enable-mysqlnd="yes" enable-swoole-json="no" enable-swoole-curl="yes"' swoole


#solution2 source code  install swool
#git clone https://github.com/swoole/swoole-src.git
cd /tmp
wget https://github.com/swoole/swoole-src/archive/refs/heads/v4.6.x.zip
unzip v4.6.x.zip
mv swoole-src-4.6.x swoole && mv swoole /usr/local/
cd /usr/local/swoole

 #  prepare the build environment for a PHP extension
phpize

#  add configuration paramaters as needed
./configure   --with-php-config=/usr/local/php7/bin/php-config

#  a successful result of make is swoole/module/swoole.so
make clean && make 

#  install the swoole into the PHP extensions directory
make install 

php --re swoole | head -1    # check swoole version