#!/bin/bash

yum install -y epel-release && yum update
yum install -y  inotify-tools

<< COMMET
#In case of CentOS-7
yum --enablerepo=epel install inotify-tools
COMMET


sysctl -w fs.inotify.max_queued_events="99999999"
sysctl -w fs.inotify.max_user_watches="99999999"
sysctl -w fs.inotify.max_user_instances="65535"

cat << EOF >> /etc/sysctl.conf
fs.inotify.max_queued_events=99999999
fs.inotify.max_user_watches=99999999
fs.inotify.max_user_instances=65535
EOF
sysctl -p

<< COMMET
#查看inotify默认参数
sysctl -a | grep max_queued_events
fs.inotify.max_queued_events = 16384

sysctl -a | grep max_user_watches
fs.inotify.max_user_watches = 8192
fs.epoll.max_user_watches = 1673768

sysctl -a | grep max_user_instances
fs.inotify.max_user_instances = 128

#修改inotify参数
1、命令修改
sysctl -w fs.inotify.max_user_instances=130
fs.inotify.max_user_instances = 130
2、文件修改
vi /etc/sysctl.conf
添加如下代码
fs.inotify.max_user_instances=130

3、参数说明
max_user_instances：每个用户创建inotify实例最大值
max_queued_events：inotify队列最大长度，如果值太小，会出现错误，导致监控文件不准确
max_user_watches：要知道同步的文件包含的目录数，可以用
# find /home/rain -type d|wc -l 统计，必须保证参数值大于统计结果（/home/rain为同步文件目录）。
COMMET


# Install supervisor
yum -y install supervisor java >/dev/null 2>&1
systemctl enable supervisord >/dev/null 2>&1
#sed -i '/inet_http_server/s/^;//' /etc/supervisord.conf
#sed -i 's/;port=.*:9001/port=0.0.0.0:9001/' /etc/supervisord.conf
sed -i 's/minfds=.*/minfds=1024000/' /etc/supervisord.conf
sed -i 's/minprocs=.*/minfds=1024000/' /etc/supervisord.conf
systemctl start supervisord >/dev/null 2>&1



#set service config
cat << EOF > /etc/supervisord.d/inotify.ini
[program:inotify]
directory = /root
command = bash inotify.sh
autostart = true
startsecs = 5
autorestart = true
startretries = 3
stopasgroup = true
user = root
EOF
supervisorctl update
supervisorctl start inotify