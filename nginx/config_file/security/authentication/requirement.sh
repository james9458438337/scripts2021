#!/bin/bash
#create user password hidden file
sh -c "echo -n 'user1:'>> /APPS/.nginxusers"
sh -c "openssl passwd -apr1 >> /APPS/.nginxusers"

