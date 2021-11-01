#!/bin/bash
printf "\033[33m %-20s %-20s %-20s \033[0m \n" Expiry_Date Left_Days Certificate

for pem in $(find /root/domain -name *.pem); do
    printf "\033[33m %-20s %-20s %-20s \033[0m \n" \
        "$(date --date="$(openssl x509 -enddate -noout -in "$pem"|cut -d= -f 2)" --iso-8601)" \
        "$(datediff $(date --iso-8601) $(date --date="$(openssl x509 -noout -in "$pem"  -enddate |cut -d= -f 2)" --iso-8601))" \
        "$pem"
done | sort