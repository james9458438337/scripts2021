#!/bin/bash
#Install Java 8
yum install -y java-1.8.0-openjdk
#Import PGP Key
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
#Create Yum repository
cat >>/etc/yum.repos.d/elk.repo<<EOF
[ELK-6.x]
name=ELK repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

#yum --showduplicates list kibana | expand
yum install -y kibana-6.4.3

Enable and start kibana service
systemctl daemon-reload
systemctl enable kibana
systemctl start kibana
#Install Nginx
yum install -y epel-release
yum install -y nginx
#Create Proxy configuration
#Remove server block from the default config file /etc/nginx/nginx.conf And create a new config file

cat >>/etc/nginx/conf.d/kibana.conf<<EOF
server {
    listen 80;
    server_name server.example.com;
    location / {
        proxy_pass http://localhost:5601;
    }
}
EOF
Enable and start nginx service
systemctl enable nginx
systemctl start nginx