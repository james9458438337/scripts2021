#!/bin/bash

###install python3 ngxtop
yum install -y epel-release python python-pip
pip install ngxtop

#log path should use full path in nginx config file
ngxtop info


###install goaccess
yum install -y epel-release goaccess


