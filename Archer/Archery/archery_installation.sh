#!/bin/bash
yum install -y unzip wet
cd /opt
wget https://github.com/hhyo/Archery/archive/refs/tags/v1.8.1.zip 
unzip /opt/v1.8.1.zip
cd Archery-1.8.1/src/docker-compose/
docker-compose -f docker-compose.yml up -d

<< 'multiline-commnet'
#表结构初始化
docker exec -ti archery /bin/bash
cd /opt/archery
source /opt/venv4archery/bin/activate
python3 manage.py makemigrations sql  
python3 manage.py migrate

#数据初始化
python3 manage.py dbshell<sql/fixtures/auth_group.sql
python3 manage.py dbshell<src/init_sql/mysql_slow_query_review.sql

#创建管理用户
python3 manage.py createsuperuser

#重启服务
docker restart archery

#日志查看和问题排查
docker logs archery -f --tail=10
logs/archery.log
multiline-commnet