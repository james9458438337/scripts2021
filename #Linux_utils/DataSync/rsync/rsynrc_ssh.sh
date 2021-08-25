#!/bin/bash

yum install sshpass -y

#rsync through ssh with password with non-interactive
sshpass -p "vagrant" rsync -e "ssh -p 22 " -azvh --progress /home/source/ vagrant@192.168.33.30:/home/vagrant/destination

#rsync through ssh with sshkey
ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
sshpass -p "vagrant" ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.33.30
rsync -e "ssh -p 22 " -azvh --progress /home/source/ vagrant@192.168.33.30:/home/vagrant/destination