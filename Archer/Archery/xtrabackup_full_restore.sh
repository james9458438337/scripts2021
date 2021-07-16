#!/bin/bash
# use xtrabackup to Fully backup mysql data per week!
# And keep current Full backup directory until next time run this script!!!
# History log

#Backup Path
BakDir=/backup
# History log
LogFile=/backup/bak.log

Begin=`date +"%Y年%m月%d日 %H:%M:%S"`

# Determing name of pervious Full backup directory
var1=`date +"%Y"`
FullBakFolder=`ls /backup/|grep $var1|grep -v '.tgz'`

innobackupex --apply-log $BakDir/$FullBakFolder

innobackupex --copy-back $BakDir/$FullBakFolder

Last=`date +"%Y年%m月%d日 %H:%M:%S"`


# Keep the time line records into logfile
echo xtrabackup_全量还原开始:$Begin 结束:$Last $GZDumpFile successful  | tee -a $LogFile