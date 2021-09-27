#!/bin/bash

wget http://sdk.bce.baidu.com/console-sdk/bce-cli-0.8.3.zip

unzip bce-cli-0.8.3.zip
cd bce-cli-0.8.3
python setup.py install


mkdir /root/.bce
cat << EOF > /root/.bce/config 
[defaults]
domain = 
region = bj
breakpoint_file_expiration = 7
https = no
multi_upload_thread_num = 10
EOF


cat << EOF >  /root/.bce/credentials
[defaults]
bce_access_key_id = c4cc984751904b59b2ed2b1737d2d350
bce_secret_access_key = 94b6a81e98534ba1b2d8f554a90e42f5
EOF

bce cdn purge --url https://download.hncssoft.com/plist/xhy202109192026.plist


bce cdn purge --directory http://my.domain.com/to/path/




wget https://sdk.bce.baidu.com/console-sdk/linux-bcecmd-0.3.0.zip
unzip -j linux-bcecmd-0.3.0.zip -d /usr/bin/

mkdir /root/.go-bcecli
cat << EOF >/root/.go-bcecli/config 
[Defaults]
Domain = 
Region = 
AutoSwitchDomain = 
BreakpointFileExpiration = 
Https = 
MultiUploadThreadNum = 100
SyncProcessingNum = 50
MultiUploadPartSize = 
EOF


cat << EOF >/root/.go-bcecli/credentials 
[Defaults]
Ak = c4cc984751904b59b2ed2b1737d2d350
Sk = 94b6a81e98534ba1b2d8f554a90e42f5
Sts = 
EOF

bcecmd bos sync /home/source bos:/vasxhyvdencpt/


bcecmd bos ls
bcecmd bos ls bos:/vasxhyvdencpt/testdir1/newfile11

