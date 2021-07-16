#!/bin/bash
#"xtrabackup_full_restore.sh" in /scripts

cd /opt/Archery-1.8.1/src/docker-compose
docker-compose -f docker-compose.yml down

mv mysql/datadir mysql/datadir_$(date +"%Y%m%d_%H%M%S")
mkdir mysql/datadir

docker run  --rm=true --name percona-innobackupex-restore-2.4 \
-v /backup:/backup -v /scripts:/scripts \
-v /opt/Archery-1.8.1/src/docker-compose/mysql/my.cnf:/etc/mysql/my.cnf \
-v /opt/Archery-1.8.1/src/docker-compose/mysql/conf.d:/etc/mysql/conf.d \
-v /opt/Archery-1.8.1/src/docker-compose/mysql/log:/var/log/mysql \
-v /opt/Archery-1.8.1/src/docker-compose/mysql/datadir:/var/lib/mysql \
percona/percona-xtrabackup:2.4  \
bash /scripts/xtrabackup_full_restore.sh

docker-compose -f docker-compose.yml up -d

docker exec -it mysql /bin/bash -c "chown -R mysql:mysql /var/lib/mysql"