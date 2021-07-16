#!/bin/bash
sudo apt-get -y install tcptraceroute

# REHL distro
#sudo yum install tcptraceroute

cd /usr/bin
sudo wget http://www.vdberg.org/~richard/tcpping
sudo chmod 755 tcpping
cd ~