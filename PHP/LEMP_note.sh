#!/bin/bash


# 1 Setting up nginx php(with extensions) composer laravel

yum install -y git tmux vim curl wget zip unzip htop

## Install PHP 7.1
yum install -y epel-release
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum --enablerepo=remi-php71 install -y php php-fpm php-cli php-common php-mcrypt php-gd  php-mysql php-pgsql php-imap php-memcached php-mbstring php-xml php-curl php-bcmatch php-sqlite3 php-xdebug
php -v

#install openssl extension
cd /usr/local/src/
curl -O -L https://github.com/php/php-src/archive/refs/heads/PHP-7.1.30.tar.gz
yum --enablerepo=remi-php71 install -y php-devel
unzip PHP-7.1.30.tar.gz
cd php-src-PHP-7.1.30/ext/openssl/
mv config0.m4 config.m4
phpize
./configure --with-openssl --with-php-config=/usr/bin/php-config
make && make install
php -m | grep openssl && php --re openssl | head -1 #check intalled and version


#Install nginx
yum install nginx -y

#Install composer
php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
composer --version
