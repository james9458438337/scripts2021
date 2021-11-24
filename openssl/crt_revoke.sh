#!/bin/bash
#domain certificat must named *.pem
#intermediate certificate must named *bundle*.crt

BOTID='2074791028'
BOTTOKEN='AAFymLc_QOTLo7TqvuDAOyg8GwVc-QRLdnM'
CHATID='-600194478'

LOGFILE="/tmp/ssl_revocation.log"
PATHNAME="/root/crt_list/domain"

alarm(){
    echo "" > $LOGFILE
    
    for pem in $(find $PATHNAME -name *.pem); do
        #full path of pem file without pem filename
        CRTPATH=$(dirname $pem)
        #pem file name with parent dir
        CRTDIR=$(echo $pem | sed "s|$PATHNAME||")
        #pem file name
        CRTNAME=$(echo $pem | sed "s|$CRTPATH/||")
        #intermedia certificate file name
        BUNDLECRT=$(find $CRTPATH/ -name *bundle*.crt)

        OCSPURI=$(openssl x509 -noout -ocsp_uri -in $pem)
        OCSPSTATUS=$(openssl ocsp -noverify -issuer $BUNDLECRT -cert $pem -url $OCSPURI | grep $CRTNAME| awk '{print $2}')
        DATETIME=$(date +"%a-%Y-%m-%d %H:%M:%S")

        if [[ $OCSPSTATUS -eq good ]]
        then
            echo "$DATETIME Certificate status $CRTDIR is $OCSPSTATUS " >> $LOGFILE
        elif [[ $OCSPSTATUS -eq revoked ]]
        then
            echo -e "$DATETIME Certificate status \033[33m$CRTDIR \033[0m is  \033[33m $OCSPSTATUS! \033[0m " >> $LOGFILE
            curl -F text="🔥🔥🔥 Certificate  $CRTDIR is $OCSPSTATUS!" -F chat_id="$CHATID" https://api.telegram.org/bot$BOTID:$BOTTOKEN/    sendmessage > /dev/null 2>&1
        else
            echo -e "$DATETIME Certificate status \033[35m$CRTDIR \033[0m is  \033[33m $OCSPSTATUS! \033[0m " >> $LOGFILE
            curl -F text="🔥🔥🔥 Certificate $CRTDIR is $OCSPSTATUS!" -F chat_id="$CHATID" https://api.telegram.org/bot$BOTID:$BOTTOKEN/    sendmessage > /dev/null 2>&1
        fi
    done
}



checkall(){
    printf "\033[33m %-30s   %-60s   %-100s  \033[0m \n" DATETIME CRTDIR OCSPSTATUS

    for pem in $(find /root/crt_list/domain -name *.pem); do
        #full path of pem file without pem filename
        CRTPATH=$(dirname $pem)
        #pem file name with parent dir
        CRTDIR=$(echo $pem | sed "s|$PATHNAME||")
        #pem file name
        CRTNAME=$(echo $pem | sed "s|$CRTPATH/||")
        #intermedia certificate file name
        BUNDLECRT=$(find $CRTPATH/ -name *bundle*.crt)

        OCSPURI=$(openssl x509 -noout -ocsp_uri -in $pem)
        OCSPSTATUS=$(openssl ocsp -noverify -issuer $BUNDLECRT -cert $pem -url $OCSPURI | grep $CRTNAME| awk '{print $2}')
        DATETIME=$(date +"%a-%Y-%m-%d %H:%M:%S")
        
        if [[ $OCSPSTATUS -eq good ]]
        then
            #echo "$DATETIME Certificate status $CRTDIR is $OCSPSTATUS "
            printf "\033[32m %-30s   %-60s   %-100s  \033[0m \n" \
            "$DATETIME" \
            "$CRTDIR" \
            "$OCSPSTATUS"

        elif [[ $OCSPSTATUS -eq revoked ]]
        then
            #echo -e "$DATETIME Certificate status \033[31m$CRTDIR \033[0m is  \033[33m $OCSPSTATUS! \033[0m "
            printf "\033[31m %-30s   %%-60s   %-100s  \033[0m \n" \
            "$DATETIME" \
            "$CRTDIR" \
            "$OCSPSTATUS"
            
        else
            #echo -e "$DATETIME Certificate status \033[31m$CRTDIR \033[0m is  \033[33m $OCSPSTATUS! \033[0m "
            printf "\033[31m %-30s   %-60s   %-100s  \033[0m \n" \
            "$DATETIME" \
            "$CRTDIR" \
            "$OCSPSTATUS"
        fi
    done
}


check(){
        printf "\033[33m %-30s   %-60s   %-100s  \033[0m \n" DATETIME CRTDIR OCSPSTATUS

        #full path of pem file with pem filename
        pem=$1
        #full path of pem file without pem filename
        CRTPATH=$(dirname $pem)
        #pem file name with parent dir
        CRTDIR=$(echo $pem | sed "s|$PATHNAME||")
        #pem file name
        CRTNAME=$(echo $pem | sed "s|$CRTPATH/||")
        #intermedia certificate file name
        BUNDLECRT=$(find $CRTPATH/ -name *bundle*.crt)

        OCSPURI=$(openssl x509 -noout -ocsp_uri -in $pem)
        OCSPSTATUS=$(openssl ocsp -noverify -issuer $BUNDLECRT -cert $pem -url $OCSPURI | grep $CRTNAME| awk '{print $2}')
        DATETIME=$(date +"%a-%Y-%m-%d %H:%M:%S")
         if [[ $OCSPSTATUS -eq good ]]
        then
            #echo "Certificate status $CRTDIR is $OCSPSTATUS "
            printf "\033[32m %-30s   %-60s   %-100s  \033[0m \n" \
            "$DATETIME" \
            "$CRTDIR" \
            "$OCSPSTATUS"

        elif [[ $OCSPSTATUS -eq revoked ]]
        then
            #echo -e "Certificate status \033[31m$CRTDIR \033[0m is  \033[33m $OCSPSTATUS! \033[0m "
            printf "\033[31m %-30s   %-60s   %-100s  \033[0m \n" \
            "$DATETIME" \
            "$CRTDIR" \
            "$OCSPSTATUS"
            
        else
            #echo -e "Certificate status \033[31m$CRTDIR \033[0m is  \033[33m $OCSPSTATUS! \033[0m "
            printf "\033[31m %-30s   %-60s   %-100s  \033[0m \n" \
            "$DATETIME" \
            "$CRTDIR" \
            "$OCSPSTATUS"
        fi
}

help(){
       cat <<- EOF
    Usage:
        /bin/bash crt_revoke.sh [options] [FILE]Options:
    Options:
        -alarm      check all certificate status and triger the telegram api if match the alarm condition
        -checkall   check all certificate status
        -check      check indicate certificate status , ex: -check [FULLPATH/FILE]
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