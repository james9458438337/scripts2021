    
#!/bin/bash
#install after nginx
yum autoremove -y php*-* remi-release
rm -fr /etc/yum.repos.d/remi* 
rm -fr /etc/php*
rm -fr /etc/opt/remi*
rm -fr /opt/remi* 
rm -fr /var/opt/remi*
rm -fr /etc/scl/prefixes/php* 
rm -fr /usr/share/Modules/modulefiles/php*  
rm -fr /var/cache/yum/x86_64/7/remi*  
rm -fr /var/lib/yum/repos/x86_64/7/remi* 
rm -fr /usr/bin/php*

yum install -y epel-release yum-utils
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum --enablerepo=remi-php74 install -y php74-php php74-php-pecl-mcrypt php74-php-cli php74-php-gd php74-php-curl php74-php-mysqlnd php74-php-ldap php74-php-zip php74-php-redis php74-php-pecl-mongodb php74-php-pecl-swoole4 php74-php-pecl-ssh2 php74-php-fileinfo php74-php-xml php74-php-intl php74-php-mbstring php74-php-opcache php74-php-process php74-php-pear php74-php-json php74-php-devel php74-php-common php74-php-bcmath php74-php-pdo php74-php-openssl php74-php-embedded php74-php-fpm php74-php-imap php74-php-odbc php74-php-xmlrpc php74-php-snmp php74-php-soap php74-php-phalcon4 php74-php-gmp

sed -i "s/apache/nginx/g" "/etc/opt/remi/php74/php-fpm.d/www.conf"
sed -i "s/listen = \/var\/opt\/remi\/php74\/run\/php-fpm\/www.sock/listen = 127.0.0.1:9000/" "/etc/opt/remi/php74php-fpm.d/www.conf"
sed -i "s/expose_php = On/expose_php = off/" "/etc/opt/remi/php74/php.ini"
sed -i "s/;pm.status_path = \/status/pm.status_path = \/status/" "/etc/opt/remi/php74/php-fpm.d/www.conf"
sed -i "s/;ping.path = \/ping/ping.path = \/ping/" "/etc/opt/remi/php74/php-fpm.d/www.conf"
chown -R root:nginx /var/opt/remi/php74/lib/php/opcache
chown -R root:nginx /var/opt/remi/php74/lib/php/session
chown -R root:nginx /var/opt/remi/php74/lib/php/wsdlcache
rm -f /usr/bin/php /usr/bin/php-cgi /usr/bin/phpize
ln -s "/usr/bin/php74" /usr/bin/php
ln -s "/usr/bin/php74-cgi" /usr/bin/php-cgi
ln -s "/usr/bin/php74-pear" /usr/bin/php-pear
ln -s "/usr/bin/php74-phar" /usr/bin/php-phar
ln -s "/opt/remi/php74/root/usr/bin/phpize" /usr/bin/phpize
ln -s "/opt/remi/php74/root/usr/bin/pecl" /usr/bin/pecl
systemctl enable --now php74-php-fpm
