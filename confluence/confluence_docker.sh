#!/bin/bash

# install docker first

mkdir /home/confluence
docker run -d -v /home/confluence/:/var/atlassian/application-data/confluence -v /etc/localtime:/etc/localtime:ro --name="confluence" -p 8090:8090 -p 8091:8091 atlassian/confluence:7.12.2-ubuntu

http://ip:8090 # get sid

docker stop confluence

docker cp confluence:/opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar /tmp/atlassian-extras-2.4.jar

cd /tmp
tar -czf atlassian-extras-2.4.jar.tar.gz atlassian-extras-2.4.jar

#cracker file ### use tar.gz to transfer ###

docker cp  /tmp/atlassian-extras-2.4.jar confluence:/opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar

docker start confluence

docker update --restart unless-stopped confluence

mkdir /home/confluence
docker run -d -v /etc/localtime:/etc/localtime:ro --name="confluence" -p 8090:8090 -p 8091:8091 atlassian/confluence:7.12.2-ubuntu
