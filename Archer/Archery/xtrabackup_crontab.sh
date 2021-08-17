#!/bin/bash
cat << EOF > /var/spool/cron/`whoami`
#每天六凌晨3:00做完全备份
0 3 * * * docker run --rm=true --name percona-innobackupex-full-2.4 \
-v /backup:/backup -v /scripts:/scripts --volumes-from mysql \
--network docker-compose_default \
percona/percona-xtrabackup:2.4  \
bash /scripts/xtrabackup_full.sh >/dev/null 2>&1
EOF