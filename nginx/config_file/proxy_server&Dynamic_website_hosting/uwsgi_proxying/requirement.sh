#!/bin/bash

#install python , this is python 2.7.5, you might change to newer version
yum install -y epel-release python python-devel
yum install -y python-pip
pip install uwsgi

#test python web with uWSGI
uwsgi --http :9090 --wsgi-file /APPS/website6/test.py --socket 127.0.0.1:2222