#!/bin/bash

wget -c https://obs-community.obs.cn-north-1.myhuaweicloud.com/obsutil/current/obsutil_linux_amd64.tar.gz -O -| tar -zx
mv obsutil* obsutil
chmod 755 -R obsutil
cd obsutil

./obsutil config -i=UTPPQVRN3AHPJ4UIPDUF -k=KAC5jwevb4LdrevFxwRms90kFiYisfcvfL1bI3iB -e=obs.ap-southeast-1.myhuaweicloud.com


#windows command
.\obsutil.exe ls obs://haha2021/VASxhy | findstr "20211020"

