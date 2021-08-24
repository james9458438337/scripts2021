#!/bin/bash
yum install -y python3
wget  https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-353.0.0-linux-x86_64.tar.gz
tar -C /usr/local/sbin/ -xzf google-cloud-sdk-353.0.0-linux-x86_64.tar.gz 
bash /usr/local/sbin/google-cloud-sdk/install.sh ## three times enter

source ~/.bashrc
gsutil version -l | grep -e "sdk" -e "gsutil path"


#config GCP project ID 
./google-cloud-sdk/bin/gcloud config set project gcp-storage-322506

#config service account HMAC key
./google-cloud-sdk/bin/gsutil config -a

#list buckets
./google-cloud-sdk/bin/gsutil ls

#list file in bucket
./google-cloud-sdk/bin/gsutil ls gs://vasxhyimg

#sync data from local to gcp
#./google-cloud-sdk/bin/gsutil -m rsync -r /home/source gs://vasxhyvd
python3 ./google-cloud-sdk/bin/bootstrapping/gsutil.py -m rsync -r /home/source/  gs://vasxhyvd/

#sync data from gcp to aws
#./bin/gsutil -m rsync -r  gs://vasxhyvd s3://vasxhyvd
python3 ./google-cloud-sdk/bin/bootstrapping/gsutil.py -m rsync -r  gs://vasxhyvd s3://vasxhyvd


##### origin source url #####
#http(s)://storage.googleapis.com/[bucket]/[object]
https://storage.googleapis.com/vasxhyvd/testfile

#or

#http(s)://[bucket].storage.googleapis.com/[object]
https://vasxhyvd.storage.googleapis.com/testfile

gsutil ls -l gs://vasxhyvd/usa | xargs -I{} gsutil du -sh  {}