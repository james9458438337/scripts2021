#install
cd /root
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
cd aws && bash install

mkdir /root/.aws/

cat << EOF > /root/.aws/config 
[default]
region = us-west-1
output = json
EOF

cat << EOF >  /root/.aws/credentials 
[default]
aws_access_key_id = AKIAUGKQUMUK6VMTG6U6
aws_secret_access_key = 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
EOF


aws s3 sync /home/www/admin/public/uploads s3://vasxhyimg/ 
