#!/bin/bash
wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.9/binary/redhat/6/x86_64/Percona-XtraBackup-2.4.9-ra467167cdd4-el6-x86_64-bundle.tar
tar xf Percona-XtraBackup-2.4.9-ra467167cdd4-el6-x86_64-bundle.tar
yum install percona-xtrabackup-24-2.4.9-1.el6.x86_64.rpm -y
which xtrabackup
innobackupex -v
