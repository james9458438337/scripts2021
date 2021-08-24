#!/bin/bash

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
Ak = 38abfa41b4c24effb2325c7837a5dc86
Sk = 82d92d13d3054738b333b5826cfc4213
Sts = 
EOF

bcecmd bos sync /home/source bos:/vasxhyvdencpt/


bcecmd bos ls
bcecmd bos ls bos:/vasxhyvdencpt/testdir1/newfile11


##### origin source url ####
https://vasxhyvdencpt.cdn.bcebos.com