#!/bin/bash
# This script is only for backup confluence in vpn connection and will run it in crontab 
password=KyW7YzJ5NgDeNevW
ip=10.64.36.133
user=qqc
local_restore_path=/home/confluence/restore/
remote_backup_path=/home/confluence/backups/
local_backup_path=$remote_backup_path
file_nums=`ls $local_restore_path | wc -l`

# keep 20 backups in the restore path, otherwise delete 20 days ago
if [ $file_nums -gt 30 ]; then
find $local_restore_path -mtime +30 -name "*.zip" | xargs rm -f
find $local_backup_path -mtime +30 -name "*.zip" | xargs rm -f
else
     return 0
fi


# get list of file those modified in one day and save as /tmp/1/txt then download to localhost in same path
cat << EOF > /tmp/getfilename.exp
#!/usr/bin/expect -f
spawn ssh $user@$ip "sudo find $remote_backup_path -mtime -$1 -type f" > /tmp/1.txt
expect \
  "(yes/no)?" {
    send "yes\r"
    expect "password:?" {
      send "$password\r"
    }
  } "password:?" {
    send "$password\r"
}
expect eof

spawn scp $user@$ip:/tmp/1.txt /tmp/1.txt
expect "password"
send "$password\r"
expect eof
EOF
/usr/bin/expect -f /tmp/getfilename.exp
rm -f /tmp/*.exp


# put list in a loop ,then verify file if existed otherwise download them to backup localation
for i in $(cat /tmp/1.txt)
do
	I=`echo $i |awk -F "/" '{print $NF}'`
	BK_files=`echo $i`
	test -f $local_restore_path$I
 if [ $? -ne 0 ]; then

cat <<EOF > /tmp/download.exp
spawn ssh $user@$ip "sudo find $remote_backup_path -mtime -$1 -type f| xargs sudo cp -t /tmp/  && sudo chown qqc:qqc /tmp/back*.zip"
expect "password"
send "$password\r"
set timeout 1000
expect eof

spawn scp $user@$ip:/tmp/$I $local_restore_path
expect "password"
send "$password\r"
set timeout 1000
expect eof

spawn ssh $user@$ip "sudo rm -f /tmp/backup*.zip"
expect "password"
send "$password\r"
set timeout 1000
expect eof
EOF

    /usr/bin/expect -f /tmp/download.exp
    docker exec confluence /bin/bash -c "chown confluence:confluence restore/* && chmod +x restore/*"

    curl -F text="PULL $I SUCCESSFULLY " -F disable_notification="false" -F chat_id="-581357601" https://api.telegram.org/bot1844283076:AAEmK-McRiY1H3-WJwVKZY3OaoOvLEVfBP8/sendmessage

 else
     echo -e "\033[35m "File is existed ignore to download:" \033[0m \033[32m $(echo $i |awk -F "/" '{print $NF}')\033[0m"

     curl -F text="File $I is existed ignore to downloa" -F disable_notification="false" -F chat_id="-581357601" https://api.telegram.org/bot1844283076:AAEmK-McRiY1H3-WJwVKZY3OaoOvLEVfBP8/sendmessage > /dev/null 2 &1
 fi
done
rm -f /tmp/*