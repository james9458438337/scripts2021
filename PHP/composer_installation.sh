#!/bin/bash

#Install latest composer
php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
composer --version

#Install version 1 composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=1.10.16 

#Install Dependencies
#Execute this in your project root.
php composer install