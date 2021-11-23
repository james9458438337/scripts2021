#!/bin/bash
#domain certificat must named *.pem
#intermediate certificate must named *bundle*.crt

LOGFILE="/tmp/ssl_revocation.log"
echo "" > $LOGFILE

for pem in $(find /root/crt_list/domain -name *.pem); do
    CRTPATH=$(dirname $pem)
    CRTDIR=$(echo $pem | sed 's|/root/crt_list/domain||')
    CRTNAME=$(echo $pem | sed "s|$CRTPATH/||")
    BUNDLECRT=$(find $CRTPATH/ -name *bundle*.crt)
    OCSPURI=$(openssl x509 -noout -ocsp_uri -in $pem)
    OCSPSTATUS=$(openssl ocsp -noverify -issuer $BUNDLECRT -cert $pem -url $OCSPURI | grep $CRTNAME| awk '{print $2}')
    if [[ $OCSPSTATUS -eq good ]]
    then
        echo "Certificate status $CRTDIR is $OCSPSTATUS " | tee -a $LOGFILE
    elif [[ $OCSPSTATUS -eq revoked ]]
    then
        echo -e "Certificate status \033[33m$CRTDIR \033[0m is  \033[33m $OCSPSTATUS! \033[0m " |tee -a $LOGFILE
        curl -F text="🔥🔥🔥 Certificate  $CRTDIR is $OCSPSTATUS!" -F chat_id="-600194478" https://api.telegram.org/bot2074791028:AAFymLc_QOTLo7TqvuDAOyg8GwVc-QRLdnM/sendmessage > /dev/null 2>&1
    else
        echo -e "Certificate status \033[35m$CRTDIR \033[0m is  \033[33m $OCSPSTATUS! \033[0m " |tee -a $LOGFILE
        curl -F text="🔥🔥🔥 Certificate $CRTDIR is $OCSPSTATUS!" -F chat_id="-600194478" https://api.telegram.org/bot2074791028:AAFymLc_QOTLo7TqvuDAOyg8GwVc-QRLdnM/sendmessage > /dev/null 2>&1
    fi
done