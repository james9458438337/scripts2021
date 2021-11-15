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

    client_max_body_size 500M;        
    client_header_timeout 3600s;
    client_body_timeout 3600s;
    fastcgi_connect_timeout 3600s;
    fastcgi_send_timeout 3600s;
    fastcgi_read_timeout 3600s;


    location ~ \.php$ {
                root kodexplorer;
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_index index.php;
                #fastcgi_param SCRIPT_FILENAME $document_root\$fastcgi_script_name;
                fastcgi_param SCRIPT_FILENAME /home/kodexplorer\$fastcgi_script_name;
                include fastcgi_params;
    }
 }
EOF


#install php7.2 with extention php-mbstring php-gd

yum install -y epel-release
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum --enablerepo=remi-php72 install -y php-cgi php-fpm php-gd php-xml php-ctype php-exif php-iconv php-json php-hash php-pdo php-mysql php-session php-sockets php-tokenizer php-mcrypt php-mbstring php-curl
php -v

#echo "extension=mbstring.so" >> /etc/php.ini
#echo "extension=php_gd2.dll" >> /etc/php.ini

cp /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.bak
cp /etc/php.ini /etc/php.ini.bak


sed -i 's/apache/nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/;request_terminate_timeout =.*/request_terminate_timeout = 3600/' /etc/php-fpm.d/www.conf
sed -i 's/pm.max_children =.*/pm.max_children = 50/' /etc/php-fpm.d/www.conf
sed -i 's/pm.start_servers =.*/pm.start_servers = 10/' /etc/php-fpm.d/www.conf
sed -i 's/pm.min_spare_servers =.*/pm.min_spare_servers = 10/' /etc/php-fpm.d/www.conf
sed -i 's/pm.max_spare_servers =.*/pm.max_spare_servers = 30/' /etc/php-fpm.d/www.conf
sed -i 's/;pm.max_requests =.*/pm.max_requests = 500/' /etc/php-fpm.d/www.conf


sed -i 's/post_max_size =.*/post_max_size = 500M/' /etc/php.ini
sed -i 's/upload_max_filesize =*/upload_max_filesize = 500M/' /etc/php.ini
sed -i 's/memory_limit =*/memory_limit = 500M/' /etc/php.ini
sed -i 's/max_execution_time =*/max_execution_time = 3600/' /etc/php.ini
sed -i 's/max_input_time =*/max_input_time = 3600/' /etc/php.ini



#install kodexplorer
mkdir /home/kodexplorer
cd /home/kodexplorer
wget http://static.kodcloud.com/update/download/kodexplorer4.46.zip
unzip kodexplorer4.46.zip
rm -f kodexplorer4.46.zip
chown root:nginx -R /home/kodexplorer
chmod -Rf 777 /home/kodexplorer

systemctl restart php-fpm nginx