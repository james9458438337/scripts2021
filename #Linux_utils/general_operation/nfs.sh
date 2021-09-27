#!/bin/bash

# server side
yum install -y nfs-utils

systemctl enable --now nfs-server rpcbind

mkdir -p /home/www/resources
chmod 777 /home/www/resources/

cat << EOF >> /etc/exports
/home/www/resources 172.31.110.208(rw,sync,no_root_squash)
/home/www/resources 172.31.110.243(rw,sync,no_root_squash)
EOF
exportfs -r

#exportfs -v: Displays a list of shares files and export options on a server.
#exportfs -a: Exports all directories listed in /etc/exports.
#exportfs -u: UnExport one or more directories.
#exportfs -r: ReExport all directories after modifying /etc/exports.


#firewall-cmd --permanent --add-service mountd
#firewall-cmd --permanent --add-service rpc-bind
#firewall-cmd --permanent --add-service nfs
#firewall-cmd --reload

-A RH-Firewall-1-INPUT -s 192.168.1.0/24 -m state --state NEW -p udp --dport 111 -j ACCEPT
-A RH-Firewall-1-INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 111 -j ACCEPT
-A RH-Firewall-1-INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 2049 -j ACCEPT
-A RH-Firewall-1-INPUT -s 192.168.1.0/24  -m state --state NEW -p tcp --dport 32803 -j ACCEPT
-A RH-Firewall-1-INPUT -s 192.168.1.0/24  -m state --state NEW -p udp --dport 32769 -j ACCEPT
-A RH-Firewall-1-INPUT -s 192.168.1.0/24  -m state --state NEW -p tcp --dport 892 -j ACCEPT
-A RH-Firewall-1-INPUT -s 192.168.1.0/24  -m state --state NEW -p udp --dport 892 -j ACCEPT
-A RH-Firewall-1-INPUT -s 192.168.1.0/24  -m state --state NEW -p tcp --dport 875 -j ACCEPT
-A RH-Firewall-1-INPUT -s 192.168.1.0/24  -m state --state NEW -p udp --dport 875 -j ACCEPT
-A RH-Firewall-1-INPUT -s 192.168.1.0/24  -m state --state NEW -p tcp --dport 662 -j ACCEPT
-A RH-Firewall-1-INPUT -s 192.168.1.0/24 -m state --state NEW -p udp --dport 662 -j ACCEP

a] TCP/UDP 111 – RPC 4.0 portmapper
b] TCP/UDP 2049 – NFSD (nfs server)
c] Portmap static ports – Various TCP/UDP ports defined in /etc/sysconfig/nfs file.

# client side

yum install -y nfs-utils

showmount -e 172.31.110.72

mkdir -p /home/www/resources

mount 172.31.110.72:/home/www/resources /home/www/resources

mount | grep /home/www/resources

cat << EOF >> /etc/fstab
172.31.110.72:/nfsfileshare /mnt/nfsfileshare    nfs     nosuid,rw,sync,hard,intr  0  0
EOF