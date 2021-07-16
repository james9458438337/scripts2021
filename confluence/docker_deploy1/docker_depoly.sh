#!/bin/bash

mkdir -p /docker/etc/nginx/sites-enabled

mkdir -p /docker/var/atlassian/application-data/confluence

mkdir -p /docker/var/lib/postgresql/data/pgdata

cp wiki /docker/etc/nginx/sites-enabled/
cp confluence.cfg.xml /docker/var/atlassian/application-data/confluence/
cp postgresql.conf /docker/var/lib/postgresql/data/pgdata/
cp pg_hba.conf /docker/var/lib/postgresql/data/pgdata/

