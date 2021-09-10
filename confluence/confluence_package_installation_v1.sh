#!/bin/bash
#This installation works for version 6.7 ----  6.15
# OS initialization
systemctl stop firewalld
setenforce 0 >/dev/null 2>&1
sed -i -e 's/^SELINUX=.*/SELINUX=disable/' /etc/sysconfig/selinux >/dev/null 2>&1
echo -e "Selinux status must be permissive : \033[32m $(getenforce)\033[0m"
rm -rf /etc/localtime >/dev/null 2>&1
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime >/dev/null 2>&1
echo -e "\033[35m "correct timezone:" \033[0m \033[32m $(date -R)\033[0m"


# Download packages
yum install -y wget expect unzip
cd /opt

wget -O atlassian-confluence-7.12.2-x64.bin https://product-downloads.atlassian.com/software/confluence/downloads/atlassian-confluence-7.12.2-x64.bin
chmod +x atlassian-confluence-7.12.2-x64.bin


wget https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-5.1.47.tar.gz
tar -zxf mysql-connector-java-5.1.47.tar.gz
docker cp mysql-connector-java*/mysql-connector-java-5.1.47-bin.jar confluence:/opt/atlassian/confluence/confluence/WEB-INF/lib/



# Install JDK8 environment
yum install -y java-1.8.0-openjdk

<< COMMENT install java manually
rpm -ivh /opt/jdk-8u211-linux-x64.rpm
cat << EOF >> /etc/profile
#Java Env
export JAVA_HOME=/usr/java/jdk1.8.0_211-amd64
export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
source /etc/profile
echo -e "\033[35m "java environment:" \033[0m \033[32m $(echo $PATH)\033[0m"
COMMENT

# Install and configurate database 
yum install -y yum-utils epel-release
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum install -y mysql-community-server mysql-community-common mysql-community-libs
systemctl start mysqld
systemctl status mysqld 
systemctl enable mysqld


sed -i '/\[mysqld\]/a\transaction-isolation=READ-COMMITTED' /etc/my.cnf
sed -i '/\[mysqld\]/a\skip-character-set-client-handshake' /etc/my.cnf
sed -i '/\[mysqld\]/a\collation-server=utf8_unicode_ci' /etc/my.cnf
sed -i '/\[mysqld\]/a\character-set-server=utf8' /etc/my.cnf
sed -i "/\[mysqld\]/a\init_connect='SET NAMES utf8'" /etc/my.cnf
sed -i "/\[mysqld\]/a\init_connect='SET collation_connection = utf8_unicode_ci'" /etc/my.cnf

#For new installations of Confluence, configure the JDBC string as follows to set the sessionVariable to enforce READ-COMMITTED
if [ -f='/etc/my.cnf.d/client.cnf' ]
then
    echo "[client]" >> /etc/my.cnf.d/client.cnf
    sed -i '/\[client\]/a\default-character-set=utf8' /etc/my.cnf.d/client.cnf

else
    sed -i '/\[client\]/a\default-character-set=utf8' /etc/my.cnf.d/client.cnf
fi

if [ -f='/etc/my.cnf.d/mysql-clients.cnf' ]
then
    echo "[client]" >> /etc/my.cnf.d/mysql-clients.cnf
    sed -i '/\[client\]/a\default-character-set=utf8' /etc/my.cnf.d/mysql-clients.cnf
else
    sed -i '/\[mysql\]/a\default-character-set=utf8' /etc/my.cnf.d/mysql-clients.cnf
fi

systemctl restart mysqld


# Create a Database for confluance
ROOTPWD=1qaz@QAZ1234
CONFLUENCE_DB=confluence
CONFLUENCE_DB_USER=confluenceuser@localhost
CONFLUENCE_DB_PASSWD=Pwd123@@@
TPWD=`grep "A temporary password" /var/log/mysqld.log | awk -F" " '{print $NF}'`

mysql -uroot -p$TPWD -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$ROOTPWD')" --connect-expired-password
mysql -uroot -p$ROOTPWD -e "create database $CONFLUENCE_DB"
mysql -uroot -p$ROOTPWD -e "CREATE USER $CONFLUENCE_DB_USER IDENTIFIED BY '$CONFLUENCE_DB_PASSWD'"
mysql -uroot -p$ROOTPWD -e "GRANT ALL PRIVILEGES ON $CONFLUENCE_DB.* TO $CONFLUENCE_DB_USER"
mysql -uroot -p$ROOTPWD -e "FLUSH PRIVILEGES"



# Install Confluence
mkdir /data
chmod +x /opt/atlassian-confluence-6.15.2-x64.bin


printf '\n%.0s' {1..7} | ./atlassian-confluence-7.12.2-x64.bin

cat << EOF > /opt/confluence.exp
#!/usr/bin/expect
spawn sh /opt/atlassian-confluence-6.15.2-x64.bin
expect "install"
send "o\r"
sleep 1
expect "installation"
send "2\r"
expect "Select"
send "/data/atlassian/confluence\r"
expect "Default"
send "/data/atlassian/application-data/confluence\r"
expect "ports"
send "1\r"
expect "background"
send "n\r"
sleep 2
expect "Start"
send "n\r"
interact
EOF
chmod +x /opt/confluence.exp
/usr/bin/expect -f /opt/confluence.exp > /tmp/expect.log

# Interaction of confluence installation  
:<<BLOCK
This will install Confluence 6.15.2 on your computer.
OK [o, Enter], Cancel [c]
Choose the appropriate installation or upgrade option.
Please choose one of the following:
Express Install (uses default settings) [1],
Custom Install (recommended for advanced users) [2, Enter],
Upgrade an existing Confluence installation [3]
Select the folder where you would like Confluence 6.15.2 to be installed,
then click Next.
Where should Confluence 6.15.2 be installed?
[/opt/atlassian/confluence]
Default location for Confluence data
[/var/atlassian/application-data/confluence]
Configure which ports Confluence will use.
Confluence requires two TCP ports that are not being used by any other
applications on this machine. The HTTP port is where you will access
Confluence through your browser. The Control port is used to Startup and
Shutdown Confluence.
Use default ports (HTTP: 8090, Control: 8000) - Recommended [1, Enter], Set custom value for HTTP and Control ports [2]
Confluence can be run in the background.
You may choose to run Confluence as a service, which means it will start
automatically whenever the computer restarts.
Install Confluence as Service?
Yes [y, Enter], No [n]
Please wait a few moments while we configure Confluence.
Installation of Confluence 6.15.2 is complete
Start Confluence now?
Yes [y, Enter], No [n]
BLOCK



#install mysql driver  "mysql-connector-java"
tar -zxf mysql-connector-java-5.1.47.tar.gz
cp mysql-connector-java*/mysql-connector-java-5.1.47-bin.jar /data/atlassian/confluence/confluence/WEB-INF/lib



# Run Confluence as a systemd service
touch /lib/systemd/system/confluence.service
chmod 664 /lib/systemd/system/confluence.service

cat << EOF > /lib/systemd/system/confluence.service
[Unit]
Description=Confluence
After=network.target
[Service]
Type=forking
User=confluence
PIDFile=/data/atlassian/confluence/work/catalina.pid
ExecStart=/data/atlassian/confluence/bin/start-confluence.sh
ExecStop=/data/atlassian/confluence/bin/stop-confluence.sh
TimeoutSec=200
LimitNOFILE=4096
LimitNPROC=4096
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable confluence
systemctl start confluence
systemctl status confluence
rm -f /opt/confluence.exp

:<<BLOCK
#other command to stop confluence
#service confluence stop
#sh /data/atlassian/confluence/bin/stop-confluence.sh
#other command to start confluence:>
#service confluence start
#sh /data/atlassian/confluence/bin/start-confluence.sh
BLOCK

#check out service on port 8090
yum install -y lsof
echo -e "\033[35m "Confluence Listening port:" \033[0m \033[32m $(echo -e "\n"&&lsof -i:8090)\033[0m"

#show how to cracker confluence
cat << EOF > /tmp/crack10years.txt
<Open the "localhost:8090">
<select "Production Installation" NEXT "do not select apps" NEXT  Copy ID number likely:"BDXK-FHS0-UNCW-7Y60">
<stop confluence and overwrite with cracked jar files then start confluence>
systemctl stop confluence
mv -f /data/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar /opt/atlassian-extras-decoder-v2-3.4.1.jar.org
cp /opt/atlassian-extras-decoder-v2-3.4.1.jar /data/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar
mv -f /data/atlassian/confluence/confluence/WEB-INF/atlassian-bundled-plugins/atlassian-universal-plugin-manager-plugin-3.0.1.jar /opt/atlassian-universal-plugin-manager-plugin-3.0.1.jar.org
cp /opt/atlassian-universal-plugin-manager-plugin-3.0.jar /data/atlassian/confluence/confluence/WEB-INF/atlassian-bundled-plugins/atlassian-universal-plugin-manager-plugin-3.0.1.jar
systemctl start confluence
< "Get an evaluation license" >
< use gmail to sgin in the atlassian account >
< select "confluence server"; field "organization" and "Server ID" then "Generate License" >
< Next >
< My Own Database >
< Database type"MySQL"; Setup type "By connection string"; Database URL "jdbc:mysql://localhost/confluence" Username "\$CONFLUENCE_DB_USE"  Password "\$CONFLUENCE_DB_PASSWD">
< "Empty Site" >
< "Manage Users and Groups within Confluence" >
< "Configure System Administrator Account" >
< "Start" >
EOF

cat << EOF > /tmp/crack300years.txt
<In this way you don't have to get online>
<Open the "localhost:8090">
<select "Production Installation" NEXT "do not select apps" NEXT  Copy ID number likely:"BDXK-FHS0-UNCW-7Y60">
<download confluence crack tool>
wget http://www.yezhou.cc/crack/confluence/confluence_crack.zip
<unzip the file>
<run the command>
java -jar confluence_keygen.jar
<fill all information and paste "Server ID">
<stop confluence and overwrite with cracked jar files then start confluence>
systemctl stop confluence
cp /data/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar /<crack tool directory name it "atlassian-extras-2.4.jar">
<then click the patch on crack tool then file will be cracked with auto backup >
<click gen to get key copy key>
cp -f /<"atlassian-extras-2.4.jar" from crack tool directory> /data/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar
mv -f /data/atlassian/confluence/confluence/WEB-INF/atlassian-bundled-plugins/atlassian-universal-plugin-manager-plugin-3.0.1.jar /opt/atlassian-universal-plugin-manager-plugin-3.0.1.jar.org
cp /opt/atlassian-universal-plugin-manager-plugin-3.0.jar /data/atlassian/confluence/confluence/WEB-INF/atlassian-universal-plugin-manager-plugin-3.0.1.jar 
systemctl start confluence
< paste key >
< Next >
< My Own Database >
< Database type"MySQL"; Setup type "By connection string"; Database URL "jdbc:mysql://localhost/confluence" Username "\$CONFLUENCE_DB_USE"  Password "\$CONFLUENCE_DB_PASSWD">
< "Empty Site" >
< "Manage Users and Groups within Confluence" >
< "Configure System Administrator Account" >
< "Start" >
EOF

cat << EOF > /tmp/notice.txt
< recover admin password >
systemctl stop confluence
sed -i '/256m/a\CATALINA_OPTS="-Datlassian.recovery.password=aaa111 \${CATALINA_OPTS}"' /data/atlassian/confluence/bin/setenv.sh
sh /data/atlassian/confluence/bin/start-confluence.sh
< login with username "recovery_admin" and change admin password>
sh /data/atlassian/confluence/bin/stop-confluence.sh
systemctl start confluence || service confluence start
< uninstall confluence >
sh /data/atlassian/confluence/uninstall
rm -rf /data/*
< update confluence >
cp /data/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar /opt/atlassian-extras-decoder-v2-3.4.1.jar.bak
< run installation for new version after backup current key file >
sh /opt/atlassian-confluence-7.3.3-x64.bin
< restore path> /data/atlassian/application-data/confluence/restore/
< export path> /data/atlassian/application-data/confluence/temp/
< daily backup path> /data/atlassian/application-data/confluence/backups/
EOF

echo -e "\033[35m "Steps for cracking confluence in 10 years:" \033[0m \033[32m $(cat /tmp/crack10years.txt)\033[0m"

echo -e "\033[35m "Steps for cracking confluence over 300 years:" \033[0m \033[32m $(cat /tmp/crack300years.txt)\033[0m"

echo -e "\033[35m "Notice for advanced features:" \033[0m \033[32m $(cat /tmp/notice.txt)\033[0m"
