#!/bin/bash

yum install -y lynx wget vim epel-release

cat << EOF  > /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch
gpgcheck=0
enable=1
EOF

#install latest version
yum --enablerepo=nginx install -y nginx

#install specific version
#yum --enablerepo=nginx --showduplicates list nginx
#yum --enablerepo=nginx install -y nginx-1.20.2-1.el7.ngx

nginx -v