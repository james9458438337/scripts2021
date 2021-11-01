#!/bin/bash
FILE="/root/icp.list"

printf "\033[33m %-30s %-30s %-30s \033[0m \n" ICPNAME IP IPGEO

while read ICPNAME; do
    IP=$(ping $ICPNAME -c 1 2> /dev/null | awk '{print $3}'| head -1|cut -d'(' -f 2 | cut -d')' -f 1)
    IPGEO=$(curl -s https://ipinfo.io/$IP | grep "country" | cut -d: -f 2|cut -d'"' -f 2)
    if [[ $IPGEO != "CN" ]]
    then
        printf "\033[31m %-30s %-30s %-30s \033[0m \n" \
        "$ICPNAME" \
        "$IP" \
        "$IPGEO"
    else
    printf "\033[33m %-30s %-30s %-30s \033[0m \n" \
        "$ICPNAME" \
        "$IP" \
        "$IPGEO"
    fi
done < $FILE | sort -k3