#!/bin/bash


#solution1 composer auto install swoft

#install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer
cd /usr/local
composer create-project swoft/swoft swoft

#solution2 composer manually install swoft

cd /tmp
wget https://github.com/swoft-cloud/swoft/archive/refs/heads/master.zip
unzip master.zip
mv swoft-master swoft && mv swoft /usr/local/
cd /usr/local/swoft

composer install --no-dev
cp .env.example .env
vim .env


#solution3 docker
docker run -p 80:80 swoft/swoft

#solution4 docker-compose
git clone https://github.com/swoft-cloud/swoft
cd swoft
docker-compose up