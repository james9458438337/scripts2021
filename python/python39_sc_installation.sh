#!/bin/bash

sudo yum -y update
sudo yum groupinstall "Development Tools" -y
sudo yum install openssl-devel libffi-devel bzip2-devel -y
sudo yum install wget -y
wget https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tgz
tar xvf Python-3.9.5.tgz
cd Python-3.9*/
./configure --enable-optimizations
sudo make altinstall
python3.9 --version
pip3.9 --version
ln -s /usr/bin/python3.9 /usr/bin/python -f
ln -s /usr/bin/pip3.6 /usr/bin/pip -f
pip install --upgrade pip
#ln -s /usr/local/bin/pip /usr/bin/pip -f
sed -i 's#/usr/bin/python#/usr/bin/python2.7#' /usr/bin/yum
sed -i 's#/usr/bin/python#/usr/bin/python2.7#' /usr/bin/yum-config-manager
sed -i 's#/usr/bin/python#/usr/bin/python2.7#' /usr/libexec/urlgrabber-ext-down