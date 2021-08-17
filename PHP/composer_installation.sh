#!/bin/bash

#Install composer
php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
composer --version


#Install Dependencies
#Execute this in your project root.
php composer install