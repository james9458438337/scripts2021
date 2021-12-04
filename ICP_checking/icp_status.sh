#!/bin/bash

which jq
if [[ $? -ne 0 ]]
then
yum install -y jq
fi

BOTID='2074791028'
BOTTOKEN='AAFymLc_QOTLo7TqvuDAOyg8GwVc-QRLdnM'
CHATID='-600194478'

LOGFILE="/tmp/icp_checking.log"
FILE="/root/icp.list"
APPKEY='40139'
TOKEN='a701ae42c3134106f6627fe8ffe9ac77'

alarm(){
    echo "" > $LOGFILE
    printf "\033[33m %-30s   %-30s   %-30s  \033[0m \n" DATETIME ICPNAME STATUS
    
    cat $FILE | grep -v "#" | while read ICPNAME; do
    sleep 1
    STATUS=$(curl -A "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -sSL "https://9322fa114435ee58.nowapi.com?app=domain.beian&domain=$ICPNAME&appkey=$APPKEY&sign=$TOKEN&format=json" | jq -jr ".result.status,.result.msg")
    DATETIME=$(date +"%a-%Y-%m-%d %H:%M:%S")
    
        if [[ $STATUS == *"ALREADY_BEIAN"* ]]
        then
            printf "\033[32m %-30s   %-30s   %-30s  \033[0m \n" "$DATETIME" "$ICPNAME" "$STATUS" | tee -a $LOGFILE
    
        else
            printf "\033[31m %-30s   %-30s   %-30s  \033[0m \n" "$DATETIME" "$ICPNAME" "$STATUS" | tee -a $LOGFILE
            curl -F text="🔥🔥🔥 $ICPNAME $STATUS!" -F chat_id="$CHATID" https://api.telegram.org/bot$BOTID:$BOTTOKEN/sendmessage > /dev/null 2>&1
        fi
    done
    curl -F text="🍀🍀🍀🍀 $DATETIME ICP checker is done!" -F chat_id="$CHATID" https://api.telegram.org/bot$BOTID:$BOTTOKEN/sendmessage> /dev/null 2>&1
}

checkall(){
    printf "\033[33m %-30s   %-30s   %-30s  \033[0m \n" DATETIME ICPNAME STATUS
    
    cat $FILE | grep -v "#" | while read ICPNAME; do
    sleep 1
    STATUS=$(curl -A "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -sSL "https://9322fa114435ee58.nowapi.com?app=domain.beian&domain=$ICPNAME&appkey=$APPKEY&sign=$TOKEN&format=json" | jq -jr ".result.status,.result.msg")
    DATETIME=$(date +"%a-%Y-%m-%d %H:%M:%S")
    
        if [[ $STATUS == *"ALREADY_BEIAN"* ]]
        then
            printf "\033[32m %-30s   %-30s   %-30s  \033[0m \n" \
            "$DATETIME" \
            "$ICPNAME" \
            "$STATUS"
        else
            printf "\033[31m %-30s   %-30s   %-30s  \033[0m \n" \
            "$DATETIME" \
            "$ICPNAME" \
            "$STATUS"
        fi
    done
}



check(){
    ICPNAME=$1
    STATUS=$(curl -A "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -sSL "https://9322fa114435ee58.nowapi.com?app=domain.beian&domain=$ICPNAME&appkey=$APPKEY&sign=$TOKEN&format=json" | jq -jr ".result.status,.result.msg")
    DATETIME=$(date +"%a-%Y-%m-%d %H:%M:%S")

    if [[ $STATUS == *"ALREADY_BEIAN"* ]]
    then
        printf "\033[32m %-30s   %-30s   %-30s  \033[0m \n" \
        "$DATETIME" \
        "$ICPNAME" \
        "$STATUS"
    else
        printf "\033[31m %-30s   %-30s   %-30s  \033[0m \n" \
        "$DATETIME" \
        "$ICPNAME" \
        "$STATUS"
    fi
}

help(){
       cat <<- EOF
    Usage:
        /bin/bash icp_status.sh [options] [DOMAIN_NAME]Options:
    Options:
        -alarm      check all domain icp status and triger the telegram api if match the alarm condition
        -checkall   check all domain icp status
        -check      check indicate domain icp status , ex: -check [DOMAIN_NAME]
        -help       Help document
EOF
}

case $1 in
  '-alarm')
    alarm
  ;;
  '-checkall')
    checkall
  ;;
  '-check')
    check $2
  ;;
  *)
    help
  ;;
esac