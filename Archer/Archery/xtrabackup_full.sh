#!/bin/bash
# use xtrabackup to Fully backup mysql data per week!
# And keep current Full backup directory until next time run this script!!!
# History log

#Backup Path
BakDir=/backup
# History log
LogFile=/backup/bak.log

Begin=`date +"%Y年%m月%d日 %H:%M:%S"`

# Keep backup files in 30 days only
/bin/find $BakDir -mtime +30 -type f -name "*.tgz" -exec rm -f {} \;

# Determing name of pervious Full backup directory
var1=`date +"%Y"`
FullBakFolder=`ls /backup/|grep $var1|grep -v '.tgz'`

# Delete pervious for Full backup directory
cd  $BakDir && /bin/rm -rf $FullBakFolder

# Full backup databases without locking tables
innobackupex --default-file=/etc/mysql/my.cnf --user=root --password=123456 --socket=/var/lib/mysql/mysqld.sock --backup $BakDir >/dev/null 2>&1

# Determing name of current Full backup directory
var2=`date +"%Y-%m-%d_%H"`
BakDestFolder=`ls $BakDir/|grep $var2|grep -v '.tgz'`

# --apply-log makse backups consistent ans should be run before restoring the backup
# Purpose of doing this here, just in case to backup, but shoud run this command again before restore backup
innobackupex --apply-log /backup/$BakDestFolder/ >/dev/null 2>&1

# wrap backup to tar file
GZDumpFile=$BakDestFolder.tgz
/bin/tar -zvcf $BakDir/$BakDestFolder.tgz $BakDir/$BakDestFolder >/dev/null 2>&1
Last=`date +"%Y年%m月%d日 %H:%M:%S"`

# Keep the time line records into logfile
echo xtrabackup_全量开始:$Begin 结束:$Last $GZDumpFile successful  | tee -a $LogFile