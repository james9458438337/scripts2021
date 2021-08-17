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
yum install -y filebeat-6.4.3

#Copy SSL certificate from server.example.com
scp server.example.com:/etc/pki/tls/certs/logstash.crt /etc/pki/tls/certs/

#Configure Filebeat
systemctl enable filebeat
systemctl start filebeat