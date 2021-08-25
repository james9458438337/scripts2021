#!/bin/bash
curl https://rclone.org/install.sh | sudo bash

#config remote storage information
rclone config


#list remote root dir
rclone listremotes

#list remote dir
rclone lsd demo:

#list remote files
rclone ls demo:/subfolders/

#copy file bewteen local and remote
rclone copy -P /home/source demo:/somewhere/

#sync file from local to remote
rclone sync -P /home/source demo:/somewhere/


#mount remote storage to local dir
yum install -y fuse
 rclone mount --daemon demo: /google_driver