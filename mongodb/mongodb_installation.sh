#!/bin/bash

cat << EOF > /etc/yum.repos.d/mongodb-org.repo
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/4.0/x86_64/
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/4.0/x86_64/
gpgcheck=1
enabled=0
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc

[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=0
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc

[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=0
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc

[mongodb-org-5.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/5.0/x86_64/
gpgcheck=1
enabled=0
gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
EOF

yum --enablerepo=mongodb-org-4.0 install -y mongodb-org



cat << EOF >> /etc/yum.conf
exclude=mongodb-org,mongodb-org-server,mongodb-org-shell,mongodb-org-mongos,mongodb-org-tools
EOF


#start mongodb
systemctl start mongod
mongod --version

#stop mongodb
#systemctl stop mongod

#reload config without restart mongodb
#systemctl reload mongod

#mongod cmd help  "db.help()"

#import example db and get query
#curl -LO https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/primer-dataset.json
#mongoimport --db test --collection restaurants --file /tmp/primer-dataset.json
#mongod
#db.restaurants.find().limit(1).pretty()
#exit

<< 'uninstall-COMMENT'
yum erase -y $(rpm -qa | grep mongodb)
rm -rf /var/log/mongodb
rm -rf /var/lib/mongo
uninstall-COMMENT