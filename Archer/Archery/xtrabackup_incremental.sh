#!/bin/bash
# Program
# use xtrabackup to Incremental backup mysql data daily!
# History log

BakDir=/backup/daily
LogFile=/backup/bak.log
Begin=`date +"%Y-%m-%d %H:%M:%S"`

# Keep backup files in 30 days only
/bin/find $BakDir -mtime +30 -type f -name "*.tgz" -exec rm -f {} \;

# Determing name of pervious Incremental backup directory
var1=`date +"%Y"`
IncrementalBakFolder=`ls $BakDir/|grep $var1|grep -v '.tgz'`

# Delete pervious for Incremental backup directory
cd $BakDir && /bin/rm -rf $IncrementalBakFolder

# Determing name of current Full backup directory
FullBakFolder=`ls /backup/|grep $var1|grep -v '.tgz'`

# begin incremental backup
innobackupex --defaults-file=/etc/mysql/my.cnf --user=root --password=123456 --socket=/var/lib/mysql/mysqld.sock --incremental $BakDir/ --incremental-basedir=/backup/$FullBakFolder/

# Determing name of current Incremental backup directory
var2=`date +"%Y-%m-%d_%H"`
BakDestFolder=`ls $BakDir/|grep $var2|grep -v '.tgz'`

# wrap backup to tar file
GZDumpFile=$BakDestFolder.tgz
/bin/tar -zvcf $BakDir/$BakDestFolder.tgz /backup/daily/$BakDestFolder
Last=`date +"%Y-%m-%d %H:%M:%S"`

# Keep the time line records into logfile
echo xtrabackup_增量开始:$Begin 结束:$Last $GZDumpFile successful | tee -a $LogFile