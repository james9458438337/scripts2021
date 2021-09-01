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
enabled=0
autorefresh=1
type=rpm-md

[ELK-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
EOF

#yum --enablerepo=ELK-6.x --showduplicates list elasticsearch | expand
yum install -y --enablerepo=ELK-6.x elasticsearch-6.4.3

<< COMMENT start with systemd
systemctl daemon-reload
systemctl enable elasticsearch
systemctl start elasticsearch
COMMENT

<< COMMENT start with init
chkconfig --add elasticsearch
chkconfig elasticsearch on
sudo -i service elasticsearch start
COMMENT



#/usr/share/elasticsearch/bin/elasticsearch --version

curl -XGET 'http://localhost:9200'



<< COMMENT Elasticsearch cluster configurations for production
#Avoiding “Split Brain” 
#decide this number: N/2 + 1
echo "discovery.zen.minimum_master_nodes: 2" >> /etc/elasticsearch/elasticsearch.yml 

#Adjusting JVM heap size
sed -i 's/## -Xms4g/-Xms8g/' /etc/elasticsearch/jvm.options
sed -i 's/## -Xmx4g/-Xmx8g/' /etc/elasticsearch/jvm.options

#Disabling swapping
sed -i '/bootstrap.mlockall/s/^#//' /etc/elasticsearch/elasticsearch.yml
sed -i '/MAX_LOCKED_MEMORY=unlimited/s/^#//'  /etc/sysconfig/elasticsearch

#Adjusting virtual memory
sysctl -a | grep vm.max_map_count
sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf

#Increasing open file descriptor limit
echo 'ulimit -SHn 65535' >> /etc/rc.local
ulimit -u 29695
ulimit -n 1024000
cat << EOF >> /etc/security/limits.conf
* soft nofile 1024000
* hard nofile 1024000
* soft nproc 29695
* hard nproc 29695
EOF

COMMENT

<< COMMENT uninstall elasticsearch
yum erase -y $(rpm -qa | grep elasticsearch)
rm -rf /var/log/elasticsearch
rm -rf /var/lib/elasticsearch
rm -rf /etc/elasticsearch
rm -rf /usr/share/elasticsearch
COMMENT