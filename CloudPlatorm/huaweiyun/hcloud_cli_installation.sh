#!/bin/bash

curl -sSL https://hwcloudcli.obs.cn-north-1.myhuaweicloud.com/cli/latest/hcloud_install.sh -o ./hcloud_install.sh && printf '\n%.0s' {1..3}|bash ./hcloud_install.sh

hcloud version

cat << EOF > /root/.hcloud/config.json 
{
        "crypter": "ukV7cEW+x7gdBu2QeU1rZ9xIRk2u9nCi7NIxqtUDHnh7+ue4rrVY/JqRsYmYF5NV",
        "nonce": "BFpEvOxq0RkTXSrhcFNIHZvlATwAKYHb",
        "language": "cn",
        "current": "default",
        "profiles": [
                {
                        "name": "default",
                        "mode": "AKSK",
                        "accessKeyId": "4V/grzs9xO0baSRJORb8jvKWbh2kG4eK+RbPkoJPDNS1uLO6",
                        "secretAccessKey": "82PAkxMKrNgmajUqJxT/vMyZZwXdyOBl/xDwoyytugf5ewtxGDJ6/ELA1XZb6Qd9pI3h2Hs6FSw=",
                        "securityToken": "",
                        "xAuthToken": "",
                        "expiresAt": "",
                        "region": "cn-north-1",
                        "projectId": "",
                        "domainId": "",
                        "readTimeout": 10,
                        "connectTimeout": 5,
                        "retryCount": 0
                }
        ]
}
EOF

