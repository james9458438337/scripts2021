#!/bin/bash

# Install supervisor
yum -y install supervisor java >/dev/null 2>&1
systemctl enable supervisord >/dev/null 2>&1
#sed -i '/inet_http_server/s/^;//' /etc/supervisord.conf
#sed -i 's/;port=.*:9001/port=0.0.0.0:9001/' /etc/supervisord.conf
sed -i 's/minfds=.*/minfds=1024000/' /etc/supervisord.conf
sed -i 's/minprocs=.*/minfds=1024000/' /etc/supervisord.conf
systemctl start supervisord >/dev/null 2>&1



#set service config
cat << EOF > /etc/supervisord.d/<service_name>.ini
[program:<service_name>]
directory = <working dir>
command = /bin/java  -jar /data/nnadminAgent/src/nn_admin_agent-SNAPSHOT.jar
autostart = false
startsecs = 5
autorestart = true
startretries = 3
user = root
EOF
supervisorctl update
supervisorctl start <service_name>
echo -e "\033[35m "Install supervisor and set agent_background service:" \033[0m \033[32m $(supervisorctl status) \033[0m"