#!/bin/bash
cat << EOF > /scripts/xtrabackup_full_restore.sh
#!/bin/bash
# use xtrabackup to Fully backup mysql data per week!
# And keep current Full backup directory until next time run this script!!!
# History log

#Backup Path
BakDir=/backup
# History log
LogFile=/backup/bak.log

Begin=\`date +"%Y年%m月%d日 %H:%M:%S"\`

# Determing name of pervious Full backup directory
var1=\`date +"%Y"\`
FullBakFolder=\`ls /backup/|grep \$var1|grep -v '.tgz'\`

innobackupex --apply-log \$BakDir/\$FullBakFolder >/dev/null 2>&1

innobackupex --copy-back \$BakDir/\$FullBakFolder >/dev/null 2>&1

Last=\`date +"%Y年%m月%d日 %H:%M:%S"\`


# Keep the time line records into logfile
echo xtrabackup_全量还原开始:\$Begin 结束:\$Last \$GZDumpFile successful  | tee -a \$LogFile
EOF
chmod +x /scripts/xtrabackup_full_restore.sh

#"xtrabackup_full_restore.sh" in /scripts

cd /opt/Archery-1.8.1/src/docker-compose
docker-compose -f docker-compose.yml down

mv mysql/datadir mysql/datadir_$(date +"%Y%m%d_%H%M%S")
mkdir mysql/datadir

docker run --rm=true --name percona-innobackupex-restore-2.4 \
-v /backup:/backup -v /scripts:/scripts \
-v /opt/Archery-1.8.1/src/docker-compose/mysql/my.cnf:/etc/mysql/my.cnf \
-v /opt/Archery-1.8.1/src/docker-compose/mysql/conf.d:/etc/mysql/conf.d \
-v /opt/Archery-1.8.1/src/docker-compose/mysql/log:/var/log/mysql \
-v /opt/Archery-1.8.1/src/docker-compose/mysql/datadir:/var/lib/mysql \
percona/percona-xtrabackup:2.4  \
bash /scripts/xtrabackup_full_restore.sh >/dev/null 2>&1

docker-compose -f docker-compose.yml up -d

docker exec -it mysql /bin/bash -c "chown -R mysql:mysql /var/lib/mysql"