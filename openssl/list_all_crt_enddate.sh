#!/bin/bash
LOGFILE="/tmp/ssl_list.log"
printf "\033[33m %-20s %-20s %-20s \033[0m \n" ExpiryDate LeftDays Certificate >$LOGFILE

for pem in $(find /root/crt_list/domain -name *.pem); do
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
done | sort -k2 >>$LOGFILE


curl -F document=@"$LOGFILE" -F chat_id="-600194478" https://api.telegram.org/bot2074791028:AAFymLc_QOTLo7TqvuDAOyg8GwVc-QRLdnM/sendDocument > /dev/null 2>&1


