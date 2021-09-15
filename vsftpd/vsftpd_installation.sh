#!/bin/bash
yum install -y vsftpd

systemctl enable -now vsftpd

cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak

#default path /var/ftp/pub/

#### Configure Anonymous only download from FTP Server
cat << EOF > /etc/vsftpd/vsftpd.conf
anonymous_enable=YES
local_enable=NO
write_enable=NO
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
no_anon_password=YES
hide_ids=YES
pasv_min_port=20000
pasv_max_port=20001
EOF
systemctl restart vsftpd

#open 20 21 20000 20001 port
firewall-cmd --permanent --add-port=20-21/tcp
firewall-cmd --permanent --add-port=20000-20001/tcp
firewall-cmd --reload

### Restrict User to Specific Directory
cat << EOF > /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
ascii_upload_enable=YES
ascii_download_enable=YES
ftpd_banner=Welcome to MyFTP
chroot_local_user=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_deny=NO
userlist_file=/etc/vsftpd/list_user_ftp
local_root=/FTP
pasv_min_port=50000
pasv_max_port=50088
EOF

groupadd ftpGroup
useradd -G ftpGroup ftpUser1
useradd -G ftpGroup ftpUser2
 echo "123abc" | passwd --stdin ftpUser1
 echo "123abc" | passwd --stdin ftpUser2

cat << EOF > /etc/vsftpd/list_user_ftp
ftpUser1
ftpUser2
EOF

mkdir -p /FTP/download
chmod 550 -R /FTP/download
chown root:ftpGroup -R /FTP/download

mkdir -p /FTP/upload 
chmod 770 -R /FTP/upload
chown root:ftpGroup -R /FTP/upload

systemctl restart vsftpd

#open 20 21 50000 50088 port
firewall-cmd --permanent --add-port=20-21/tcp
firewall-cmd --permanent --add-port=50000-50088/tcp
firewall-cmd --reload



### Restrict User to Home Directory
cat << EOF > /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
ascii_upload_enable=YES
ascii_download_enable=YES
ftpd_banner=Welcome to MyFTP
chroot_local_user=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_deny=NO
userlist_file=/etc/vsftpd/list_user_ftp
user_sub_token=\$USER
local_root=/home/\$USER/ftp
pasv_min_port=40033
pasv_max_port=40088
EOF


useradd ftpUser1
useradd ftpUser2
 echo "123abc" | passwd --stdin ftpUser1
 echo "123abc" | passwd --stdin ftpUser2

mkdir -p /home/ftpUser1/ftp/upload
chmod 550  /home/ftpUser1/ftp
chmod 750  /home/ftpUser1/ftp/upload
chown -R ftpUser1: /home/ftpUser1/ftp

mkdir -p /home/ftpUser2/ftp/upload
chmod 550  /home/ftpUser2/ftp
chmod 750  /home/ftpUser2/ftp/upload
chown -R ftpUser2: /home/ftpUser2/ftp

cat << EOF > /etc/vsftpd/list_user_ftp
ftpUser1
ftpUser2
EOF

systemctl restart vsftpd

#open 20 21 40033 40088 port
firewall-cmd --permanent --add-port=20-21/tcp
firewall-cmd --permanent --add-port=40033-40088/tcp
firewall-cmd --reload


### Secure VSFTPD server with TLS/SSL
cat << EOF > /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
ascii_upload_enable=YES
ascii_download_enable=YES
ftpd_banner=Welcome to MyFTP
chroot_local_user=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
local_root=/ftp
userlist_deny=NO
userlist_file=/etc/vsftpd/list_user_ftp
pasv_min_port=43333
pasv_max_port=48888

ssl_enable=YES
ssl_tlsv1_2=YES
ssl_sslv2=NO
ssl_sslv3=NO
rsa_cert_file=/etc/vsftpd/tls-ssl-vsftpd.pem
rsa_private_key_file=/etc/vsftpd/tls-ssl-vsftpd.pem
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
require_ssl_reuse=NO
ssl_ciphers=HIGH
debug_ssl=YES
EOF

groupadd ftpGroup
useradd -G ftpGroup ftpUser1
useradd -G ftpGroup ftpUser2
 echo "123abc" | passwd --stdin ftpUser1
 echo "123abc" | passwd --stdin ftpUser2

cat << EOF > /etc/vsftpd/list_user_ftp
ftpUser1
ftpUser2
EOF

mkdir -p /ftp/upload
mkdir -p /ftp/download
chmod 550  /ftp/download
chmod 770  /ftp/upload
chown -R root:ftpGroup /ftp/

openssl req -x509 -nodes -keyout /etc/vsftpd/tls-ssl-vsftpd.pem -out /etc/vsftpd/tls-ssl-vsftpd.pem -days 365 -newkey rsa:2048 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

systemctl restart vsftpd

#open 20 21 40033 40088 port
firewall-cmd --permanent --add-port=990/tcp
firewall-cmd --permanent --add-port=43333-48888/tcp
firewall-cmd --reload


### Allow Everyone Download ON Ubuntu
cat << EOF > /etc/vsftpd/vsftpd.conf
anonymous_enable=YES
local_enable=NO
anon_root=/ftp_only_download/
no_anon_password=YES
hide_ide=YES
pasv_min_port=40000
pasv_max_port=50000
EOF

mkdir -p /ftp_only_download/
chown nobody:nogroup /ftp_only_download/
mkdir -p /ftp_only_download/download

systemctl restart vsftpd

#open 20 21 40033 40088 port
ufw allow 20:21/tcp
ufw allow 40000:50000/tcp


### Allow Users Local Login ON Ubuntu
cat << EOF > /etc/vsftpd/vsftpd.conf
listen=NO
listen_ipv6=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
user_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
pam_service_name-vsftpd
force_dot_files=YES
pasv_min_port=40000
pasv_max_port=50000
userlist_enable=YES
userlist_file=/etc/vsftpd/list_user_ftp
userlist_deny=NO
user_sub_token=\$USER
local_root=/home/\$USER/ftp
EOF

useradd -m ftpUser1
 echo "123abc" | passwd --stdin ftpUser1

mkdir -p /home/ftpUser1/ftp
chown nobody:nogroup /home/ftpUser1/ftp/
chmod 555 /home/ftpUser1/ftp/

mkdir -p /home/ftpUser1/ftp/data
chown ftpUser1:ftpUser1 /home/ftpUser1/ftp/data/
chmod 755 /home/ftpUser1/ftp/

