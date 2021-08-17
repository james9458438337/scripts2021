#!/bin/bash
# Program
# use xtrabackup to Incremental backup mysql data daily!
# History
# Path
BakDir=/backup/daily
LogFile=/backup/bak.log
Begin=`date +"%Y年%m月%d日 %H:%M:%S"`

# Keep backup files in 30 days only
/bin/find $BakDir -mtime +30 -type f -name "*.tgz" -exec rm -f {} \;

# Determing name of pervious Incremental backup directory
var1=`date +"%Y"`
IncrementalBakFolder=`ls /backup/daily/|grep $var1|grep -v '.tgz'`

# Delete pervious for Incremental backup directory
/bin/rm -rf /backup/daily/$IncrementalBakFolder

# Determing name of current Full backup directory
FullBakFolder=`ls /backup/|grep $var1|grep -v '.tgz'`

# begin incremental backup
innobackupex --defaults-file=/etc/my.cnf --user=root --password='1qaz!QAZ' --socket=/data/mysql/mysql.sock --incremental $BakDir/ --incremental-basedir=/backup/$FullBakFolder/ >/dev/null 2>&1

# Determing name of current Incremental backup directory
var2=`date +"%Y-%m-%d_%H"`
BakDestFolder=`ls /backup/daily/|grep $var2|grep -v '.tgz'`

# wrap backup to tar file 
GZDumpFile=$BakDestFolder.tgz
/bin/tar -zvcf /backup/daily/$BakDestFolder.tgz /backup/daily/$BakDestFolder >/dev/null 2>&1
Last=`date +"%Y年%m月%d日 %H:%M:%S"`

# Keep the time line records into logfile
echo xtrabackup_增量开始:$Begin 结束:$Last $GZDumpFile successful | tee -a $LogFile