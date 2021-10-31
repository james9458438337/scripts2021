#! /bin/bash
yum install https://repo.ius.io/ius-release-el7.rpm -y
yum install yum-utils -y
yum install python36u -y

ln -s /usr/bin/python3 /usr/bin/python -f
ln -s /usr/bin/pip3 /usr/bin/pip -f
pip install --upgrade pip
ln -s /usr/local/bin/pip /usr/bin/pip -f
sed -i 's#/usr/bin/python#/usr/bin/python2.7#' /usr/bin/yum
sed -i 's#/usr/bin/python#/usr/bin/python2.7#' /usr/bin/yum-config-manager
sed -i 's#/usr/bin/python#/usr/bin/python2.7#' /usr/libexec/urlgrabber-ext-down