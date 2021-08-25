#!/bin/bash
##### server side #####

#create user same as client side (source side)
mkdir /home/backup && chown -R nginx:nginx /home/backup
useradd -s /sbin/nologin -M nginx
echo "rsyncbackup:^Y&U*I(O123456" > /etc/rsync.pass
chmod 600 /etc/rsync.pass
cp /etc/rsyncd.conf /etc/rsyncd.conf.bak
cat << EOF > /etc/rsyncd.conf
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsync.log
motd file = /etc/rsyncd.Motd
ignore errors
max connections = 200
timeout = 300
port = 10873

[backup]
path = /home/resource
comment = "backup dirtory"
uid = nginx
gid = nginx
use chroot = yes
read only = no
list = yes
auth users = rsyncbackup
secrets file = /etc/rsyncd.pass
hosts allow = 192.168.33.0/24
EOF

cat << EOF > /etc/rsyncd.Motd
THIS IS BACKUP STORAGE FOR PROJECT'S RESOURCES
EOF

systemctl enable --now rsyncd


#client side
echo "^Y&U*I(O123456" > /etc/rsync.pass
chmod 600 /etc/rsync.pass

#list modules
rsync --port=10873 192.168.33.30::

#list files inside module
rsync --list-only --port=10873 rsyncbackup@192.168.33.30::backup --password-file=/etc/rsyncd.pass

#push files to server side
rsync -avz --port=10873 /home/source/ rsyncbackup@192.168.33.30::backup --password-file=/etc/rsyncd.pass