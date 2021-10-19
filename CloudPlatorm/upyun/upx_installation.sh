#!/bin/bash

#install golang
wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz
cat << EOF >> /etc/profile
export PATH=$PATH:/usr/local/go/bin
EOF
source /etc/profile
cat << EOF >> ~/.bash_profile
export PATH=$PATH:/usr/local/go/bin
EOF

source ~/.bash_profile

#install upx
git clone https://github.com/upyun/upx.git
cd upx && make