#!/bin/bash

#Disable SELinux or Put in in Permissive mode
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

#Step 1: Install PHP and httpd
sudo yum -y install epel-release yum-utils
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --disable remi-php54
sudo yum-config-manager --enable remi-php74
sudo yum -y install vim httpd php php-cli php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json php-pdo php-pecl-apcu php-pecl-apcu-devel
php -v


#Step 2: Install and Configure MariaDB / MySQL
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum install -y mysql-community-server mysql-community-common mysql-community-libs
systemctl start mysqld
systemctl status mysqld 
systemctl enable mysqld
TEMPROOTPWD="`grep "A temporary password" /var/log/mysqld.log | awk -F" " '{print $NF}'`"

cat << EOF >> /tmp/mysql.sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newPassword=123';
FLUSH PRIVILEGES;
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY "StrongPassword=123";
CREATE DATABASE nextcloud;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EOF

mysql -uroot -p$TEMPROOTPWD < /tmp/mysql.sql

#Step 3: Download and Install Nextcloud on CentOS 7
sudo yum -y install wget unzip
wget https://download.nextcloud.com/server/releases/nextcloud-21.0.2.zip
unzip nextcloud*.zip
rm -f nextcloud*.zip
sudo mv nextcloud/ /var/www/html/
sudo mkdir /var/www/html/nextcloud/data
sudo chown apache:apache -R /var/www/html/nextcloud

#Step 4: Configure Apache VirtualHost – Without SSL
cat << EOF >> /etc/httpd/conf.d/nextcloud.conf
<VirtualHost *:80>
  #ServerName files.example.com
  #ServerAdmin admin@example.com
  DocumentRoot /var/www/html/nextcloud/
  Alias /nextcloud "/var/www/html/nextcloud/"
  <directory /var/www/html/nextcloud>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    SetEnv HOME /var/www/html/nextcloud
    SetEnv HTTP_HOME /var/www/html/nextcloud
  </directory>
</VirtualHost>
EOF

sudo systemctl enable --now httpd

#Configure SELinux:
#sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html(/.*)?"
#sudo sudo restorecon -Rv /var/www/html

#Configure Firewall:
#sudo firewall-cmd --add-service={http,https} --permanent
#sudo firewall-cmd --reload


#Step 5: Configure Apache With Let’s Encrypt SSL
<< 'HTTPS-COMMENT'
sudo yum -y install epel-release
sudo yum -y install certbot
export DOMAIN="files.example.com"
export EMAIL="admin@example.com"
sudo certbot certonly --standalone -d $DOMAIN --preferred-challenges http --agree-tos -n -m $EMAIL --keep-until-expiring

cat << EOF >> /etc/httpd/conf.d/nextcloud.conf
<VirtualHost *:80>
   ServerName files.example.com
   ServerAdmin admin@example.com
   RewriteEngine On
   RewriteCond %{HTTPS} off
   RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R=301,L]
</VirtualHost>

<IfModule mod_ssl.c>
   <VirtualHost *:443>
     ServerName files.example.com
     ServerAdmin admin@example.com
     DocumentRoot /var/www/html/nextcloud
     <directory /var/www/html/nextcloud>
        Require all granted
        AllowOverride All
        Options FollowSymLinks MultiViews
        SetEnv HOME /var/www/html/nextcloud
        SetEnv HTTP_HOME /var/www/html/nextcloud
    </directory>
     SSLEngine on
     SSLCertificateFile /etc/letsencrypt/live/files.example.com/fullchain.pem
     SSLCertificateKeyFile /etc/letsencrypt/live/files.example.com/privkey.pem
   </VirtualHost>
</IfModule>
EOF

HTTPS-COMMENT