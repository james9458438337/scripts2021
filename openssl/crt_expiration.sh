#!/bin/bash
which datediff
if [[ $? -ne 0 ]]
then
wget http://download.opensuse.org/repositories/utilities/RHEL_7/utilities.repo -O /etc/yum.repos.d/utilities.repo
yum install -y dateutils
fi

BOTID='2074791028'
BOTTOKEN='AAFymLc_QOTLo7TqvuDAOyg8GwVc-QRLdnM'
CHATID='-600194478'

LOGFILE="/tmp/ssl_validate.log"
PATHNAME="/root/crt_list/domain"

alarm(){
    echo "" > $LOGFILE
    
    for pem in $(find $PATHNAME*.pem); do
        #pem file name with parent dir
        CRTPATH=$(echo $pem | sed "s|$PATHNAME||")
        #validate days of certificate before expiration
        LeftDays=$(datediff $(date --iso-8601) $(date --date="$(openssl x509 -noout -in "$pem" -enddate |cut -d= -f 2)" --iso-8601))
        DATETIME=$(date +"%a-%Y-%m-%d %H:%M:%S")
    
        if [[ $LeftDays -ge 30 ]]
        then
            echo "$DATETIME Certificate $CRTPATH is good for $LeftDays days!" >> $LOGFILE
        elif [[ $LeftDays -le 30 ]]
        then
            echo -e "$DATETIME Certificate \033[33m$CRTPATH \033[0m will expired within \033[33m $LeftDays days! \033[0m " >> $LOGFILE
            curl -F text="🔥🔥🔥 Certificate  $CRTPATH will expired within $LeftDays days!" -F chat_id="-600194478" https://api.telegram.org/bot$BOTID:$BOTTOKEN/sendmessage > /dev/null 2>&1
        elif [[ $LeftDays -lt 0 ]]
        then
            echo -e "$DATETIME Certificate \033[35m$CRTPATH \033[0m has expired \033[31m $LeftDays days ago! \033[0m " >> $LOGFILE
            curl -F text=" 🔥🔥🔥 Certificate $CRTPATH expired $LeftDays days ago!" -F chat_id="-600194478" https://api.telegram.org/bot$BOTID:$BOTTOKEN/sendmessage > /dev/null 2>&1
        else
            echo -e "$DATETIME Certificate \033[35m$CRTPATH \033[0m is invalid/not found" >> $LOGFILE
            curl -F text="🔥🔥🔥 Certificate $CRTPATH invalid/not found" -F chat_id="-600194478" https://api.telegram.org/bot$BOTID:$BOTTOKEN/sendmessage > /dev/null 2>&1
        fi
    done
}



sendlog(){
    echo "" > $LOGFILE
    printf "\033[33m %-20s %-20s %-20s \033[0m \n" ExpiryDate LeftDays Certificate >$LOGFILE    
    for pem in $(find $PATHNAME -name *.pem); do
        #date of expiration
        ExpiryDate=$(date --date="$(openssl x509 -enddate -noout -in "$pem"|cut -d= -f 2)" --iso-8601)
        #validate days of certificate before expiration
        LeftDays=$(datediff $(date --iso-8601) $(date --date="$(openssl x509 -noout -in "$pem"  -enddate |cut -d= -f 2)" --iso-8601))    
        if [[ $LeftDays -le 30 ]]
        then
            printf "\033[31m %-20s %-20s %-20s \033[0m \n" \
                "$ExpiryDate" \
                "$LeftDays" \
                "$pem"    
        else
            printf "\033[32m %-20s %-20s %-20s \033[0m \n" \
              "$ExpiryDate" \
              "$LeftDays" \
              "$pem"
        fi
    done | sort -k2 >>$LOGFILE
    curl -F document=@"$LOGFILE" -F chat_id="$CHATID" https://api.telegram.org/bot$BOTID:$BOTTOKEN/sendDocument > /dev/null 2>&1
}




checkall(){
    printf "\033[33m %-20s %-20s %-20s \033[0m \n" ExpiryDate LeftDays Certificate

    for pem in $(find $PATHNAME -name *.pem); do
        #date of expiration
        ExpiryDate=$(date --date="$(openssl x509 -enddate -noout -in "$pem"|cut -d= -f 2)" --iso-8601)
        #validate days of certificate before expiration
        LeftDays=$(datediff $(date --iso-8601) $(date --date="$(openssl x509 -noout -in "$pem"  -enddate |cut -d= -f 2)" --iso-8601))
        
        if [[ $LeftDays -le 30 ]]
        then
            printf "\033[31m %-20s %-20s %-20s \033[0m \n" \
                "$ExpiryDate" \
                "$LeftDays" \
                "$pem"
    
        else
            printf "\033[32m %-20s %-20s %-20s \033[0m \n" \
              "$ExpiryDate" \
              "$LeftDays" \
              "$pem"
        fi
    done
}



check(){
    printf "\033[33m %-20s %-20s %-20s \033[0m \n" ExpiryDate LeftDays Certificate

    #full path of pem file with pem filename
    pem=$1
    #date of expiration
    ExpiryDate=$(date --date="$(openssl x509 -enddate -noout -in "$pem"|cut -d= -f 2)" --iso-8601)
    #validate days of certificate before expiration
    LeftDays=$(datediff $(date --iso-8601) $(date --date="$(openssl x509 -noout -in "$pem"  -enddate |cut -d= -f 2)" --iso-8601))
    if [[ $LeftDays -le 30 ]]
    then
        printf "\033[31m %-20s %-20s %-20s \033[0m \n" \
            "$ExpiryDate" \
            "$LeftDays" \
            "$pem"

    else
        printf "\033[32m %-20s %-20s %-20s \033[0m \n" \
          "$ExpiryDate" \
          "$LeftDays" \
          "$pem"
    fi
}


help(){
       cat <<- EOF
    Usage:
        /bin/bash icp_status.sh [options] [FILE]Options:
    Options:
        -alarm      check all certificates expiration status and triger the telegram api if match the alarm condition
        -sendlog    send log to api. ex: telegram
        -checkall   check all certificates expiration status
        -check      check indicate certificates expiration status , ex: -check [FULLPATH/FILE]
        -help       Help document
EOF
}

case $1 in
  '-alarm')
    alarm
  ;;
  '-sendlog')
    sendlog
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