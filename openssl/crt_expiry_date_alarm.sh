#!/bin/bash
which datediff
if [[ $? -ne 0 ]]
then
wget http://download.opensuse.org/repositories/utilities/RHEL_7/utilities.repo -O /etc/yum.repos.d/utilities.repo
yum install -y dateutils
fi

LOGFILE="/tmp/ssl_checking.log"
echo "" > $LOGFILE

for pem in $(find /root/crt_list/domain -name *.pem); do
    CRT=$(echo $pem | sed 's|/root/crt_list/domain||')
    LeftDays=$(datediff $(date --iso-8601) $(date --date="$(openssl x509 -noout -in "$pem" -enddate |cut -d= -f 2)" --iso-8601))
    if [[ $LeftDays -ge 30 ]]
    then
        echo "Certificate $CRT is good for $LeftDays days!" | tee -a $LOGFILE
    elif [[ $LeftDays -le 30 ]]
    then
        echo -e "Certificate \033[33m$CRT \033[0m will expired within \033[33m $LeftDays days! \033[0m " |tee -a $LOGFILE
        curl -F text="🔥🔥🔥 Certificate  $CRT will expired within $LeftDays days!" -F chat_id="-600194478" https://api.telegram.org/bot2074791028:AAFymLc_QOTLo7TqvuDAOyg8GwVc-QRLdnM/sendmessage > /dev/null 2>&1
    elif [[ $LeftDays -lt 0 ]]
    then
        echo -e "Certificate \033[35m$CRT \033[0m has expired \033[31m $LeftDays days ago! \033[0m " |tee -a $LOGFILE
        curl -F text=" 🔥🔥🔥 Certificate $CRT expired $LeftDays days ago!" -F chat_id="-600194478" https://api.telegram.org/bot2074791028:AAFymLc_QOTLo7TqvuDAOyg8GwVc-QRLdnM/sendmessage > /dev/null 2>&1
    else
        echo -e "Certificate \033[35m$CRT \033[0m is invalid/not found" |tee -a $LOGFILE
        curl -F text="🔥🔥🔥 Certificate $CRT invalid/not found" -F chat_id="-600194478" https://api.telegram.org/bot2074791028:AAFymLc_QOTLo7TqvuDAOyg8GwVc-QRLdnM/sendmessage > /dev/null 2>&1
    fi
done