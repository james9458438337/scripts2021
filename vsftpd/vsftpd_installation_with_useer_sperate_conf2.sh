#!/bin/bash
yum install -y vsftpd

systemctl enable -now vsftpd

cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak

###  User login ftp server

#1.Add user file
cat << EOF > /etc/vsftpd/list_user_ftp
ftpuser1
ftpuser2
EOF

chmod 600 /etc/vsftpd/list_user_ftp

#2.Establish local mapping user and set host directory permission
useradd ftpuser1
useradd ftpuser2
 echo "123abc" | passwd --stdin ftpuser1
 echo "123abc" | passwd --stdin ftpuser2

mkdir -p /home/ftpuser1/ftp
chmod -R 550  /home/ftpuser1/ftp
mkdir -p /home/ftpuser1/ftp/upload
chmod -R 750  /home/ftpuser1/upload
#chown -R ftpUser1: /home/ftpuser1

mkdir -p /home/ftpuser2/ftp
chmod -R 550  /home/ftpuser1/ftp
mkdir -p /home/ftpuser2/ftp/upload
chmod -R 750  /home/ftpuser1/upload
#chown -R ftpUser1: /home/ftpuser1

#5.Configure vsftpd.conf (set virtual user configuration item)

cat << EOF > /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
pam_service_name=vsftpd
hide_ids=YES
dirmessage_enable=YES
xferlog_enable=YES
vsftpd_log_file=/var/log/vsftpd.log
xferlog_std_format=YES
xferlog_file=/var/log/xferlog
connect_from_port_20=YES
ascii_upload_enable=YES
ascii_download_enable=YES
ftpd_banner=Welcome to MyFTP
chroot_local_user=YES
userlist_enable=YES
userlist_deny=NO
userlist_file=/etc/vsftpd/list_user_ftp
listen=NO
listen_ipv6=YES
pasv_min_port=50000
pasv_max_port=50088
tcp_wrappers=YES
user_config_dir=/etc/vsftpd/vsftpd_user_conf
EOF



mkdir /etc/vsftpd/vsftpd_user_conf
cat << EOF > /etc/vsftpd/vsftpd_user_conf/ftpuser1
write_enable=YES
user_sub_token=\$USER
local_root=/home/ftp/\$USER
#allow_writeable_chroot=YES
local_umask=077
file_open_mode=0666
EOF

cat << EOF > /etc/vsftpd/vsftpd_user_conf/ftpuser2
write_enable=YES
user_sub_token=\$USER
local_root=/home/ftp/\$USER
#allow_writeable_chroot=YES
local_umask=077
file_open_mode=0666
EOF


systemctl restart vsftpd

