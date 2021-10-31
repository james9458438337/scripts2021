#!/bin/bash
echo "正在安装相关组件"
yum install -y openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel gcc-c++ gcc libffi-devel zlib* yum-utils -y
 
echo "下载安装包"
wget https://www.python.org/ftp/python/3.7.5/Python-3.7.5.tgz 
 
echo "正在解压安装包"
tar -xf Python-3.7.5.tgz >/dev/null 2>&1 && echo "Extract tgz done!!" && cd Python-3.7.5 
 
echo "添加ssl支持"
cat >> /root/Python-3.7.5/Modules/Setup.dist <<"EOF"
_socket socketmodule.c
 
SSL=/usr/local/ssl
_ssl _ssl.c \
-DUSE_SSL -I$(SSL)/include -I$(SSL)/include/openssl \
-L$(SSL)/lib -lssl -lcrypto
EOF
 
echo "正在编译安装Python"
mkdir /usr/local/src/python3
./configure --prefix=/usr/local/src/python3 >/dev/null 2>&1 && echo "configuration done!!"
sleep 3
make >/dev/null 2>&1 && echo "make  done!!"
sleep 3
make install >/dev/null 2>&1 && echo "make install done!!"
cd ~
 
echo "删除安装包"
rm -rf Python-3.7.5.tgz && rm -rf ./Python-3.7.5
 
echo "正在添加环境变量"
ln -s /usr/local/src/python3/bin/python3 /usr/bin/python -f
ln -s /usr/local/src/python3/bin/pip3 /usr/bin/pip -f
sed -i 's#/usr/bin/python#/usr/bin/python2.7#' /usr/bin/yum
sed -i 's#/usr/bin/python#/usr/bin/python2.7#' /usr/bin/yum-config-manager
sed -i 's#/usr/bin/python#/usr/bin/python2.7#' /usr/libexec/urlgrabber-ext-down
#echo "export PATH=/usr/local/python/bin:$PATH">> ~/.bash_profile
#source ~/.bash_profile
 
echo "安装完成,请执行python3进行测试"
python -V & pip -V
python -c "import ssl; print(ssl.OPENSSL_VERSION)"
pip install --upgrade pip
#curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
#python get-pip.py
python -V & pip -V