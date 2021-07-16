#!/bin/bash
cat << EOF > /var/spool/cron/`whoami`
#每个星期日凌晨3:00执行完全备份脚本
0 3 * * 0 /bin/bash -x /home/centos/xtrabackup_full.sh >/dev/null 2>&1
#周一到周六凌晨3:00做增量备份
0 3 * * 1-6 /bin/bash -x /home/centos/xtrabackup_incremental.sh >/dev/null 2>&1
EOF
sudo mkdir -p /backup/daily