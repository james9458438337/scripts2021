#!/bin/bash

#disable selinux and firewall 
#install nginx
yum install -y nginx unzip

cat << EOF > /etc/nginx/conf.d/kodexplorer.conf
server {
    listen 80;
    server_name localhost;
    root /home/kodexplorer/;
    index  index.html index.htm index.php;

        location ~ \.php$ {
                root kodexplorer;
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_index index.php;
                #fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param SCRIPT_FILENAME /home/kodexplorer$fastcgi_script_name;
                include fastcgi_params;
        }
 }
EOF
systemctl restart nginx

#install php7.2 with extention php-mbstring php-gd

yum install -y epel-release
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum --enablerepo=remi-php72 install -y php php-fpm php-zip php-cli php-common php-mcrypt php-gd  php-mysql php-pgsql php-imap php-memcached php-mbstring php-xml php-curl php-bcmatch php-sqlite3 php-xdebug
php -v

sed -i "s/apache/nginx/g" "/etc/php-fpm.d/www.conf"
#echo "extension=mbstring.so" >> /etc/php.ini
#echo "extension=php_gd2.dll" >> /etc/php.ini

systemctl restart php-fpm


#install kodexplorer
mkdir /home/kodexplorer
cd /home/kodexplorer
wget http://static.kodcloud.com/update/download/kodexplorer4.46.zip
unzip kodexplorer4.46.zip
rm -f kodexplorer4.46.zip
chown root:nginx -R /home/kodexplorer
chmod -Rf 777 /home/kodexplorer