#!/bin/bash
printf "\033[33m %-30s   %-30s   %-30s   %-30s \033[0m \n" ICPNAME IP IPGEO

for ICPNAME in $1; do
    DATETIME=$(date +"%a-%Y-%m-%d %H:%M:%S")
    IP=$(ping $ICPNAME -c 1 2> /dev/null | awk '{print $3}'| head -1|cut -d'(' -f 2 | cut -d')' -f 1)
    IPGEO=$(curl -s https://ipinfo.io/$IP?token=a9bb8e18267bc7 | grep "country" | cut -d: -f 2|cut -d'"' -f 2)
    if [[ -z "$IP" ]]
    then
        printf "\033[31m %-30s   %-30s   %-30s   %-30s \033[0m \n" \
        "$ICPNAME" \
        "$IP" \
        "$IPGEO"
    else
        printf "\033[33m %-30s   %-30s   %-30s   %-30s \033[0m \n" \
        "$ICPNAME" \
        "$IP" \
        "$IPGEO"
    fi
done