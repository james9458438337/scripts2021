#!/bin/bash


#solution1
yum install -y epel-release
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm


## Install PHP 7.2
#Detail ref LEMP_note.sh
yum --enablerepo=remi-php72 install -y php php-fpm php-zip php-cli php-common php-mcrypt php-gd  php-mysql php-pgsql php-imap php-memcached php-mbstring php-xml php-curl php-bcmatch php-sqlite3 php-xdebug
php -v
## Install PHP 7.3 
#yum --enablerepo=remi-php73 install php
## Install PHP 7.4 
#yum --enablerepo=remi-php74 install php

#install openssl extension
cd /usr/local/src/
curl -O -L https://github.com/php/php-src/archive/refs/heads/PHP-7.2.34.zip
yum --enablerepo=remi-php72 install -y php-devel
unzip PHP-7.2.34.zip
cd PHP-7.2.34/ext/openssl/
mv config0.m4 config.m4
phpize
./configure --with-openssl --with-php-config=/usr/bin/php-config
make && make install
php -m | grep openssl && php --re openssl | head -1 #check intalled and version


#solution2 from source code ####take too long time####

yum install epel-release -y
yum -y install gcc gcc-c++  make zlib zlib-devel pcre pcre-devel  libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers sqlite-devel oniguruma-devel libpng12 perl perl-devel libxslt libxslt-devel 

cd /usr/local/src
wget http://ftp.gnu.org/gnu/bison/bison-2.4.1.tar.gz
tar -zxvf bison-2.4.1.tar.gz
cd bison-2.4.1/
./configure
make
make install

cd /usr/local/src
curl -O -L https://github.com/php/php-src/archive/refs/heads/PHP-7.2.34.tar.gz
tar -xvf PHP-7.2.34.tar.gz
cd /usr/local/src/php-src-PHP-7.2.34 
./buildconf --force
./configure --prefix=/usr/local/php7 --enable-mbstring  --enable-ftp  --enable-gd-jis-conv --enable-mysqlnd --enable-pdo   --enable-sockets   --enable-fpm   --enable-xml  --enable-soap  --enable-pcntl   --enable-cli   --with-openssl  --with-mysqli=mysqlnd   --with-pdo-mysql=mysqlnd   --with-pear   --with-zlib  --with-iconv  --with-curl
make clean
make
make test
make install


cat << EOF > /etc/systemd/system/php-fpm.service
[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=simple
PIDFile=/var/run/php-fpm.pid
ExecStart=/usr/local/php7/sbin/php-fpm --nodaemonize --fpm-config /usr/local/php7/etc/php-fpm.conf
ExecReload=/bin/kill -USR2 $MAINPID
ExecStop=/bin/kill -SIGINT $MAINPID

[Install]
WantedBy=multi-user.target
EOF

chmod +x /etc/systemd/system/php-fpm.service
ln -s /usr/local/php7/bin/* /usr/bin/


echo 'export PATH=/usr/local/php7/bin:$PATH' >> /root/.bash_profile
echo 'export PATH=/usr/local/php7/sbin:$PATH' >> /root/.bash_profile
source /root/.bash_profile
cd /usr/local/php7/lib
cp /usr/local/src/php-src-PHP-7.2.34/php.ini-development ./php.ini


#vi php.ini
#echo 'pathmunge /usr/local/php7/bin' > /etc/profile.d/php.sh
php -v
#ext will auto add to php.ini
/usr/local/php7/bin/pear config-set php_ini '/usr/local/php7/lib/php.ini'