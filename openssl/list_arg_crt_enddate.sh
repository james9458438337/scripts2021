#!/bin/bash
printf "\033[33m %-20s %-20s %-20s \033[0m \n" ExpiryDate LeftDays Certificate

for pem in $1; do
    ExpiryDate=$(date --date="$(openssl x509 -enddate -noout -in "$pem"|cut -d= -f 2)" --iso-8601)
    LeftDays=$(datediff $(date --iso-8601) $(date --date="$(openssl x509 -noout -in "$pem"  -enddate |cut -d= -f 2)" --iso-8601))
    if [[ $LeftDays -le 30 ]]
    then
        printf "\033[31m %-20s %-20s %-20s \033[0m \n" \
            "$ExpiryDate" \
            "$LeftDays" \
            "$pem"

    else
        printf "\033[33m %-20s %-20s %-20s \033[0m \n" \
          "$ExpiryDate" \
          "$LeftDays" \
          "$pem"
    fi
done | sort -k2