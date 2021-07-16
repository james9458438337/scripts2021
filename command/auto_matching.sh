#!/bin/bash
# $1 is app name i.e "avgo"
# $2 is cdn domain-name i.e "avgovdhw.yilundii.cn"
# $3 is planfrom name i.e "huaweiyun"
# bash auto_matching.sh avgo avgovdhw.yilundii.cn huaweiyun

DATE_DIR=`date --date="yesterday" "+%Y%m%d"`
test ! -d /home/qqc/pre_hit_domain  && mkdir -p  /home/qqc/pre_hit_domain
cd /data/dspVideo/hls/$1/data/

# For getting yesterday uri only
if test ! -d upload/$DATE_DIR; then
echo -e "\033[31m "$1 new uri on $DATE_DIR is not existed" \033[0m";
else
    find upload/$DATE_DIR -name "*.m3u8" > /tmp/$1.file
    find upload/$DATE_DIR -name "*.ts" >> /tmp/$1.file
fi

# For getting full history uri
#find updoad/ -name "*.m3u8" > /tmp/$1.file
#find upload/ -name "*.ts" >> /tmp/$1.file
while read LINE; do echo https://$2/hls/"$LINE"; done < /tmp/$1.file > /tmp/$1.$3_domain



#sed -i 's/^/https\:\/\//' baidu/*

