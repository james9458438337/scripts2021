#!/bin/bash

yum install -y lsyncd
lsyncd --version

<< COMMENT
#install from source code
yum install -y lua lua-devel asciidoc cmake
wget https://github.com/axkibe/lsyncd/archive/refs/heads/master.zip
unzip  master.zip
cd lsyncd-master
cmake
#cmake -DCMAKE_INSTALL_PREFIX=/usr/local/lsyncd
make 
make install
COMMENT

cp /etc/lsyncd.conf /etc/lsyncd.conf.bak
cat << EOF > /etc/lsyncd.conf
settings {
     logfile = "/var/log/lsyncd/lsyncd.log",
     statusFile = "/var/log/lsyncd/lsyncd.status"
}

sync { default.rsync, source = "/home/source", target = "rsyncbackup@192.168.33.30::backup", delete="running", exclude = { ".*", ".tmp" }, delay = 30, init = false, rsync = { binary = "/bin/rsync", archive = true, compress = true, verbose   = true, password_file = "/etc/rsyncd.passwd",_extra = {"--port=10873"} } }
EOF

cat << EOF > /usr/lib/systemd/system/lsyncd.service
[Unit]
Description=Live Syncing (Mirror) Daemon
After=network.target

[Service]
Restart=always
Type=simple
Nice=19
#EnvironmentFile=-/etc/default/lsyncd
#ExecStart=/usr/bin/sh -c 'eval `/usr/bin/lsyncd -nodaemon $LSYNCD_OPTIONS /etc/lsyncd/lsyncd.conf.lua`'
ExecStart=/usr/bin/lsyncd -nodaemon -pidfile /run/lsyncd.pid /etc/lsyncd.conf
ExecReload=/bin/kill -HUP $MAINPID
PIDFile=/run/lsyncd.pid

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl enable --now lsyncd