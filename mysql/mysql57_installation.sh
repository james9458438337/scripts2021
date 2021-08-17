#!=/bin/bash
## Mysql5.7  Installation with yum
echo 'export HISTTIMEFORMAT="%F %T %t"' >> ~/.bash_profile
source ~/.bash_profile
sysctl -w net.ipv4.ip_local_reserved_ports="6000-9500,20000-23500"
sysctl -p
ulimit -u 29695
ulimit -n 102400
cat  << EOF >> /etc/security/limits.conf
* soft nofile 102400
* hard nofile 102400
* soft nproc 29695
* hard nproc 29695
EOF




yum install -y yum-utils wget epel-release

rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum install -y mysql-community-server mysql-community-common mysql-community-libs
systemctl start mysqld
systemctl status mysqld 
systemctl enable mysqld
MASTER_DB_USER='root'
MASTER_DB_PASSWD='P^@$#@!t^@J#N@KgL$2^!'
grep "A temporary password" /var/log/mysqld.log | awk -F" " '{print $NF}'


#installation from source
#wget  ftp://204.236.174.29:51210/mysql_install/* --user=inituser --password='Q+Q_C.net@20$1=9'
unzip mysql_6603.zip
groupadd mysql
useradd -r -g mysql -s /bin/false -M mysql
mv mysqld6603 /etc/init.d/
chmod +x /etc/init.d/mysqld6603
chkconfig mysqld6603 on
cp -r mysql_6603 /home/
chown -R mysql.mysql /home/mysql_6603
ln -s /home/mysql_6603/bin/mysqld_safe /usr/bin/mysqld6603
ln -s /home/mysql_6603/bin/mysql /usr/bin/mysql6603
echo "#/home/mysql_6603/bin/mysqld_safe --defaults-file=/home/mysql_6603/my.cnf --user=mysql &" >>/etc/rc.local
chmod +x /etc/rc.d/rc.local
chmod +x /home/mysql_6603/bin/*
 rm -fr /etc/my.cnf*
/home/mysql_6603/bin/mysqld  --defaults-file=/home/mysql_6603/my.cnf --initialize --user=mysql --basedir=/home/mysql_6603/ --datadir=/home/mysql_6603/data/
echo "done,now you can use mysql6603 -P 6603 -S /home/mysql_6603/mysql.sock -uroot -p to login"


#reset password
mysql --connect-expired-password -uroot -p'yourpassword' -P 3306 -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';"

#alternative way to change password by update tables
#UPDATE mysql.user SET authentication_string = PASSWORD('NEW_USER_PASSWORD') WHERE User = 'user-name' AND Host = 'localhost';
#FLUSH PRIVILEGES;

#create db user privileges 
mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD -e "create database game character set utf8 collate utf8_bin"
mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD -e "create database nn_admin character set utf8 collate utf8_bin"
mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD -e 'create user "K@$0!@^7^0iP^FO$#US!R"@"%" identified BY "P^@$!$^#@!t^@1@K#OL$2^!"'
mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD -e 'grant all privileges on game.* to "K@$0!@^7^0iP^FO$#US!R"@"%"'
mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD -e 'grant all privileges on nn_admin.* to "K@$0!@^7^0iP^FO$#US!R"@"%"'
mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD -e "flush privileges"
mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD -e 'show grants for "K@$0!@^7^0iP^FO$#US!R"@"%"'

#restore database
mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD nn_admin < /root/nnadmin_2020_11_18.sql
mysql -u$MASTER_DB_USER -p$MASTER_DB_PASSWD game < /root/game_2020_11_18.sql