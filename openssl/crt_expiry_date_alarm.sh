#!/bin/bash
LOGFILE="/tmp/ssl_checking.log"
echo "" > $LOGFILE

for pem in $(find /root/domain -name *.pem); do
    LeftDays=$(datediff $(date --iso-8601) $(date --date="$(openssl x509 -noout -in "$pem" -enddate |cut -d= -f 2)" --iso-8601))
    if [[ $LeftDays -ge 30 ]]
    then
        echo "Certificate $pem is good for $LeftDays days!" | tee -a $LOGFILE
    elif [[ $LeftDays -le 30 ]]
    then
        echo -e "Certificate \033[33m $pem \033[0m will expired within \033[33m $LeftDays days! \033[0m " | tee -a $LOGFILE
        curl -F text="$(hostname) 🔥🔥🔥 Certificate  $pem will expired within $LeftDays days!" -F chat_id="-581357601" https://api.telegram.org/bot1844283076:AAEmK-McRiY1H3-WJwVKZY3OaoOvLEVfBP8/sendmessage > /dev/null 2>&1
    elif [[ $LeftDays -lt 0 ]]
    then
        echo -e "Certificate \033[35m $pem \033[0m has expired \033[31m $LeftDays days ago! \033[0m " | tee -a $LOGFILE
        curl -F text="$(hostname) 🔥🔥🔥 Certificate $pem has expired $LeftDays days ago!" -F chat_id="-581357601" https://api.telegram.org/bot1844283076:AAEmK-McRiY1H3-WJwVKZY3OaoOvLEVfBP8/sendmessage > /dev/null 2>&1
    else
        echo -e "Certificate \033[35m $pem \033[0m is invalid/not found" |tee -a $LOGFILE
        curl -F text="$(hostname) 🔥🔥🔥 Certificate $pem is invalid/not found" -F chat_id="-581357601" https://api.telegram.org/bot1844283076:AAEmK-McRiY1H3-WJwVKZY3OaoOvLEVfBP8/sendmessage > /dev/null 2>&1

    fi
done

