#!/bin/bash

pecl install igbinary
pecl install zstd
printf "yes" | pecl install redis
pecl list| grep redis