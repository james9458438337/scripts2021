#!/bin/bash
wget https://openresty.org/package/centos/openresty.repo -O /etc/yum.repos.d/openresty.repo
yum check-update
yum --disablerepo="*" --enablerepo="openresty" --showduplicates list openresty | expand

yum install -y openresty-1.19.3.2 openresty-openssl.x86_64 openresty-pcre-devel.x86_64 openresty-zlib.x86_64 openresty-resty-1.19.3.2 openresty-openssl-devel.x86_64 openresty-doc-1.19.3.2 openresty-opm-1.19.3.2

mkdir /usr/local/openresty/nginx/conf.d

systemctl enable --now openresty

