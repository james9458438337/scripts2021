#!/bin/bash
#install ab tool 
yum install -y gcc make automake curl curl-devel httpd-devel autoconf libtool pcre pcre-devel libxml2 libxml2-devel

#install ModSecurity
mkdir -p /opt/install
cd /opt/install
git clone --depth 1  -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity.git
cd ModSecurity
git submodule init
git submodule update
./build.sh
./configure --prefix=/APPS/ModSec
make
make install

#install ModSecurity nginx connector
cd /opt/install
git clone --depth 1  https://github.com/SpiderLabs/ModSecurity-nginx.git





#compile nginx with ModSecurity module
#downlaod dependencies, Minimumd ependencies to compile nginx: PCRE  ZIP  SSL
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
export MODSECURITY_INC=/APPS/ModSec/include/
export MODSECURITY_LIB=/APPS/ModSec/lib/
./configure --prefix=/APPS/nginx.modsec  --add-dynamic-module=/opt/install/ModSecurity-nginx --with-http_ssl_module --with-openssl=/opt/install/openssl-1.0.2t --with-pcre=/opt/install/pcre-8.45 --with-zlib=/opt/install/zlib-1.2.11
make
make install


#load ModSec module start nginx
sed -i '/pid/a load_module /APPS/nginx.modsec/modules/ngx_http_modsecurity_module.so;' /APPS/nginx.modsec/conf/nginx.conf
/APPS/nginx.modsec/sbin/nginx

#download security rules
mkdir /APPS/nginx.modsec/modsec
wget https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended -O /APPS/nginx.modsec/modsec/modsecurity.conf

sed -i '/SecRuleEngine/s/^/#/' /APPS/nginx.modsec/modsec/modsecurity.conf
sed -i '/#SecRuleEngine/a SecRuleEngine On' /APPS/nginx.modsec/modsec/modsecurity.conf

grep SecRuleEngine /APPS/nginx.modsec/modsec/modsecurity.conf



cat << EOF > /APPS/nginx.modsec/modsec/main.conf
Include "/APPS/nginx.modsec/modsec/modsecurity.conf"
#Basic rule
SecRule REQUEST_URI "@beginWith /admin" "phase:2,t:lowercase, id:2222, deny, msg: 'admin is blocked'"
EOF

cp /APPS/nginx.modsec/modsec/modsecurity.conf  /APPS/nginx.modsec/modsec/unicode.mapping