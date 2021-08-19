#!/bin/bash
wget  https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-353.0.0-linux-x86_64.tar.gz
tar -xzf google-cloud-sdk-353.0.0-linux-x86_64.tar.gz
cd google-cloud-sdk && bash install.sh ## three times enter

#config GCP project ID 
./bin/gcloud config set project gcp-storage-322506

#config service account HMAC key
./bin/gsutil config -a

#list buckets
./bin/gsutil ls

#list file in bucket
./bin/gsutil ls gs://vasxhyimg

#sync data from local to gcp
./bin/gsutil -m rsync -r /home/source gs://vasxhyvd

#sync data from gcp to aws
./bin/gsutil -m rsync -r  gs://vasxhyvd s3://vasxhyvd