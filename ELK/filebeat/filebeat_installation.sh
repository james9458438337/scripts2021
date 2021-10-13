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

[ELK-7.x]
name=ELK repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

#yum --enablerepo=ELK-6.x --showduplicates list filebeat| expand
yum install -y --enablerepo=ELK-6.x filebeat-6.4.3-1


#Copy SSL certificate from server.example.com
scp server.example.com:/etc/pki/tls/certs/logstash.crt /etc/pki/tls/certs/

#Configure Filebeat
<< COMMENT start with systemd
systemctl daemon-reload
systemctl enable filebeat
systemctl start filebeat
COMMENT

<< COMMENT start with init
chkconfig --add filebeat
chkconfig filebeat on
sudo -i service filebeat start
COMMENT


filebeat test config
filebeat test config -e -c filebeat.yml