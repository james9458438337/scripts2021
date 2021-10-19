#!/bin/bash

#wget http://sdk.bce.baidu.com/console-sdk/bce-cli-0.8.3.zip
wget https://sdk.bce.baidu.com/console-sdk/bce-cli-0.10.10.zip
unzip bce-cli-0.10.10.zip
cd bce-cli-0.10.10
python setup.py install


mkdir /root/.bce_pxwl0007
cat << EOF > /root/.bce_pxwl0007/config 
[defaults]
domain = 
region = bj
breakpoint_file_expiration = 7
https = no
multi_upload_thread_num = 10
EOF


cat << EOF >  /root/.bce_pxwl0007/credentials
[defaults]
bce_access_key_id = 7aea6cbaebd54f438a045b9bf72359d3
bce_secret_access_key = 70a7541a37054381bf5066eadfd5a870
EOF




mkdir /root/.bce_cdn001
cat << EOF > /root/.bce_cdn001/config 
[defaults]
domain = 
region = bj
breakpoint_file_expiration = 7
https = no
multi_upload_thread_num = 10
EOF


cat << EOF >  /root/.bce_cdn001/credentials
[defaults]
bce_access_key_id = c4cc984751904b59b2ed2b1737d2d350
bce_secret_access_key = 94b6a81e98534ba1b2d8f554a90e42f5
EOF


