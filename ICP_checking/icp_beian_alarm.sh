#!/bin/bash
LOGFILE="/tmp/icp_checking.log"
echo "" > $LOGFILE
FILE="/root/icp.list"

while read ICPNAME; do
DATETIME=$(date +"%a-%Y-%m-%d %H:%M:%S")
IP=$(ping $ICPNAME -c 1 2> /dev/null | awk '{print $3}'| head -1|cut -d'(' -f 2 | cut -d')' -f 1)
IPGEO=$(curl -s https://ipinfo.io/$IP | grep "country" | cut -d: -f 2|cut -d'"' -f 2)
    if [[ -z "$IP" ]]
    then
        echo "$DATETIME   $ICPNAME   BEI AN is good" | tee -a $LOGFILE
    else
        echo -e "\033[31m$DATETIME   $ICPNAME   BEI AN is droped \033[0m " | tee -a $LOGFILE
        curl -F text="🔥🔥🔥 $ICPNAME BEI AN is droped!" -F chat_id="-581357601" https://api.telegram.org/bot1844283076:AAEmK-McRiY1H3-WJwVKZY3OaoOvLEVfBP8/sendmessage > /dev/null 2>&1
    fi
done < $FILE