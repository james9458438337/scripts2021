#!/bin/bash

wget http://www.flyvpn.com/files/downloads/linux/flyvpn-x86_64-4.1.1.0.tar.gz -O /tmp/flyvpn.tar.gz
mkdir /usr/local/flyvpn
tar -zxvf /tmp/flyvpn.tar.gz -C /usr/local/flyvpn
ln -s /usr/local/flyvpn/flyvpn /bin/flyvpn 

cat << EOF >/etc/flyvpn.conf
user Your-Account-Name
pass Your-Password
EOF

cat << EOF > /root/vpnhk.sh
flyvpn login && printf tcp |flyvpn connect "Hong Kong #350" &
EOF

cat << EOF > /root/vpnsh.sh
flyvpn login && printf tcp |flyvpn connect "Shanghai #108" &
EOF

chmod +x /root/vpn*.sh