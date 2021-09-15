#!/bin/bash
yum install -y vsftpd

systemctl enable -now vsftpd

cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak

### Virtual User login ftp server

###Establish vsftpd virtual user

#1.Add virtual user password file to install vsftpd
cat << EOF > /etc/vsftpd/virtual_users_list
vuser001
123abc
vuser002
123abc
EOF

chmod 600 /etc/vsftpd/virtual_users_list

#2.Generate virtual user password authentication file
yum install -y db4-utils db4
db_load -T -t hash -f /etc/vsftpd/virtual_users_list /etc/vsftpd/vsftpd_login.db
chmod 600 /etc/vsftpd/vsftpd_login.db


#3.Edit PAM authentication file of vsftpd
cat << EOF > /etc/pam.d/vsftpd_virtual
#%PAM-1.0
auth    required        pam_userdb.so   db=/etc/vsftpd/vsftpd_login crypt=hash
account required        pam_userdb.so   db=/etc/vsftpd/vsftpd_login crypt=hash
session required        pam_loginuid.so
EOF

#4.Establish local mapping user and set host directory permission
useradd -s /sbin/nologin -d /home/ftp vsftpd
chown -R vsftpd:vsftpd /home/ftp


mkdir -p /home/ftp/virtual_users/vuser001
mkdir -p /home/ftp/virtual_users/vuser002
chown -R vsftpd: /home/ftp/virtual_users
chmod -R 700  /home/ftp/virtual_users

#5.Configure vsftpd.conf (set virtual user configuration item)

cat << EOF > /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
virtual_use_local_privs=YES
pam_service_name=vsftpd_virtual
guest_enable=YES
guest_username=vsftpd
user_sub_token=\$USER
local_root=/home/ftp/virtual_users/\$USER
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
allow_writeable_chroot=YES
listen=NO
listen_ipv6=YES
userlist_deny=NO
pasv_min_port=50000
pasv_max_port=50088
tcp_wrappers=YES
user_config_dir=/etc/vsftpd/vsftpd_user_conf
EOF


mkdir /etc/vsftpd/vsftpd_user_conf
cat << EOF > /etc/vsftpd/vsftpd_user_conf/vuser001
virtual_use_local_privs=NO
write_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=NO
local_umask=077
file_open_mode=0666
anon_umask=077
chown_upload_mode=0600
EOF

cat << EOF > /etc/vsftpd/vsftpd_user_conf/vuser002
virtual_use_local_privs=NO
write_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=NO
local_umask=077
file_open_mode=0666
anon_umask=077
chown_upload_mode=0600
EOF


systemctl restart vsftpd

