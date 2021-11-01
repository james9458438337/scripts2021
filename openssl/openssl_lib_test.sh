#!/bin/bash

#remove remote host fingerprint from lcoal ~/.ssh/know_hosts
ssh-keygen -R 192.168.34.1

#create directory infrastructure
# The root ca would normally be offline and never connect to the network. The intermedia ca can be online but often not on the same system as other servers

mkdir -p ca/{root-ca,sub-ca,server}/{private,certs,newcerts,crl,csr}
chmod -v 700 ca/{root-ca,sub-ca,server}/private

#create index file and serial file
touch ca/{root-ca,sub-ca}/index
openssl rand -hex 16 > ca/root-ca/serial
openssl rand -hex 16 > ca/sub-ca/serial

#create private key for root ca with passphrases "123456"
cd ca
openssl genrsa -aes256 -out root-ca/private/ca.key 4096


#create private key for sub ca with passphrases "654321"
openssl genrsa -aes256 -out sub-ca/private/sub-ca.key 4096


#create private key for server without passphrases
openssl genrsa -out server/private/server.key 2048

#create root ca config file
cat << EOF > root-ca/root-ca.conf
[ca]
#/root/ca/root-ca/root-ca.conf
#see man ca
default_ca    = CA_default

[CA_default]
dir     = /root/ca/root-ca
certs     =  \$dir/certs
crl_dir    = \$dir/crl
new_certs_dir   = \$dir/newcerts
database   = \$dir/index
serial    = \$dir/serial
RANDFILE   = \$dir/private/.rand

private_key   = \$dir/private/ca.key
certificate   = \$dir/certs/ca.crt

crlnumber   = \$dir/crlnumber
crl    =  \$dir/crl/ca.crl
crl_extensions   = crl_ext
default_crl_days    = 30

default_md   = sha256

name_opt   = ca_default
cert_opt   = ca_default
default_days   = 365
preserve   = no
policy    = policy_strict

[ policy_strict ]
countryName   = supplied
stateOrProvinceName  =  supplied
organizationName  = match
organizationalUnitName  =  optional
commonName   =  supplied
emailAddress   =  optional

[ policy_loose ]
countryName   = optional
stateOrProvinceName  = optional
localityName   = optional
organizationName  = optional
organizationalUnitName   = optional
commonName   = supplied
emailAddress   = optional

[ req ]
# Options for the req tool, man req.
default_bits   = 2048
distinguished_name  = req_distinguished_name
string_mask   = utf8only
default_md   =  sha256
# Extension to add when the -x509 option is used.
x509_extensions   = v3_ca

[ req_distinguished_name ]
countryName                     = Country Name (2 letter code)
stateOrProvinceName             = State or Province Name
localityName                    = Locality Name
0.organizationName              = Organization Name
organizationalUnitName          = Organizational Unit Name
commonName                      = Common Name
emailAddress                    = Email Address
countryName_default  = GB
stateOrProvinceName_default = England
0.organizationName_default = TheUrbanPenguin Ltd

[ v3_ca ]
# Extensions to apply when createing root ca
# Extensions for a typical CA, man x509v3_config
subjectKeyIdentifier  = hash
authorityKeyIdentifier  = keyid:always,issuer
basicConstraints  = critical, CA:true
keyUsage   =  critical, digitalSignature, cRLSign, keyCertSign

[ v3_intermediate_ca ]
# Extensions to apply when creating intermediate or sub-ca
# Extensions for a typical intermediate CA, same man as above
subjectKeyIdentifier  = hash
authorityKeyIdentifier  = keyid:always,issuer
#pathlen:0 ensures no more sub-ca can be created below an intermediate
basicConstraints  = critical, CA:true, pathlen:0
keyUsage   = critical, digitalSignature, cRLSign, keyCertSign

[ server_cert ]
# Extensions for server certificates
basicConstraints  = CA:FALSE
nsCertType   = server
nsComment   =  "OpenSSL Generated Server Certificate"
subjectKeyIdentifier  = hash
authorityKeyIdentifier  = keyid,issuer:always
keyUsage   =  critical, digitalSignature, keyEncipherment
extendedKeyUsage  = serverAuth
EOF

#create root certificate using "openssl req" command with root private key ,Common Name : RootCA 
cd root-ca
openssl req -config root-ca.conf -key private/ca.key -new -x509 -days 7500 -sha256 -extensions v3_ca -out certs/ca.crt

openssl x509 -noout -in certs/ca.crt -text


#create sub ca config file
cd ../sub-ca
cat << EOF > sub-ca.conf
[ca]
#/root/ca/sub-ca/sub-ca.conf
#see man ca
default_ca    = CA_default

[CA_default]
dir     = /root/ca/sub-ca
certs     =  \$dir/certs
crl_dir    = \$dir/crl
new_certs_dir   = \$dir/newcerts
database   = \$dir/index
serial    = \$dir/serial
RANDFILE   = \$dir/private/.rand

private_key   = \$dir/private/sub-ca.key
certificate   = \$dir/certs/sub-ca.crt

crlnumber   = \$dir/crlnumber
crl    =  \$dir/crl/ca.crl
crl_extensions   = crl_ext
default_crl_days    = 30

default_md   = sha256

name_opt   = ca_default
cert_opt   = ca_default
default_days   = 365
preserve   = no
policy    = policy_loose

[ policy_strict ]
countryName   = supplied
stateOrProvinceName  =  supplied
organizationName  = match
organizationalUnitName  =  optional
commonName   =  supplied
emailAddress   =  optional

[ policy_loose ]
countryName   = optional
stateOrProvinceName  = optional
localityName   = optional
organizationName  = optional
organizationalUnitName   = optional
commonName   = supplied
emailAddress   = optional

[ req ]
# Options for the req tool, man req.
default_bits   = 2048
distinguished_name  = req_distinguished_name
string_mask   = utf8only
default_md   =  sha256
# Extension to add when the -x509 option is used.
x509_extensions   = v3_ca

[ req_distinguished_name ]
countryName                     = Country Name (2 letter code)
stateOrProvinceName             = State or Province Name
localityName                    = Locality Name
0.organizationName              = Organization Name
organizationalUnitName          = Organizational Unit Name
commonName                      = Common Name
emailAddress                    = Email Address
countryName_default  = GB
stateOrProvinceName_default = England
0.organizationName_default = TheUrbanPenguin Ltd

[ v3_ca ]
# Extensions to apply when createing root ca
# Extensions for a typical CA, man x509v3_config
subjectKeyIdentifier  = hash
authorityKeyIdentifier  = keyid:always,issuer
basicConstraints  = critical, CA:true
keyUsage   =  critical, digitalSignature, cRLSign, keyCertSign

[ v3_intermediate_ca ]
# Extensions to apply when creating intermediate or sub-ca
# Extensions for a typical intermediate CA, same man as above
subjectKeyIdentifier  = hash
authorityKeyIdentifier  = keyid:always,issuer
#pathlen:0 ensures no more sub-ca can be created below an intermediate
basicConstraints  = critical, CA:true, pathlen:0
keyUsage   = critical, digitalSignature, cRLSign, keyCertSign

[ server_cert ]
# Extensions for server certificates
basicConstraints  = CA:FALSE
nsCertType   = server
nsComment   =  "OpenSSL Generated Server Certificate"
subjectKeyIdentifier  = hash
authorityKeyIdentifier  = keyid,issuer:always
keyUsage   =  critical, digitalSignature, keyEncipherment
extendedKeyUsage  = serverAuth
# Extension to add when the -x509 option is used.
x509_extensions   = v3_ca

[ req_distinguished_name ]
countryName                     = Country Name (2 letter code)
stateOrProvinceName             = State or Province Name
localityName                    = Locality Name
0.organizationName              = Organization Name
organizationalUnitName          = Organizational Unit Name
commonName                      = Common Name
emailAddress                    = Email Address
countryName_default  = GB
stateOrProvinceName_default = England
0.organizationName_default = TheUrbanPenguin Ltd

[ v3_ca ]
# Extensions to apply when createing root ca
# Extensions for a typical CA, man x509v3_config
subjectKeyIdentifier  = hash
authorityKeyIdentifier  = keyid:always,issuer
basicConstraints  = critical, CA:true
keyUsage   =  critical, digitalSignature, cRLSign, keyCertSign

[ v3_intermediate_ca ]
# Extensions to apply when creating intermediate or sub-ca
# Extensions for a typical intermediate CA, same man as above
subjectKeyIdentifier  = hash
authorityKeyIdentifier  = keyid:always,issuer
#pathlen:0 ensures no more sub-ca can be created below an intermediate
basicConstraints  = critical, CA:true, pathlen:0
keyUsage   = critical, digitalSignature, cRLSign, keyCertSign

[ server_cert ]
# Extensions for server certificates
basicConstraints  = CA:FALSE
nsCertType   = server
nsComment   =  "OpenSSL Generated Server Certificate"
subjectKeyIdentifier  = hash
authorityKeyIdentifier  = keyid,issuer:always
keyUsage   =  critical, digitalSignature, keyEncipherment
extendedKeyUsage  = serverAuth
EOF


#create sub-ca certificate sigining request CSR using "openssl req" command with sub-ca private key ,Common Name : SubCA 
openssl req -config sub-ca.conf -new -key private/sub-ca.key -sha256 -out csr/sub-ca.csr


#create sub-ca certificate using "openssl ca" comamnd by sigining sub-ca csr
cd -
openssl ca -config root-ca.conf -extensions v3_intermediate_ca -days 3650 -notext -in ../sub-ca/csr/sub-ca.csr -out ../sub-ca/certs/sub-ca.crt

openssl x509 -noout -text -in ../sub-ca/certs/sub-ca.crt


#create server certificate sigining request CSR using "openssl req" command with sub-ca private key ,Common Name : www.example.com
cd ../server
openssl req -key private/server.key -new -sha256 -out csr/server.csr


#create server certificate using "openssl ca" comamnd by sigining server csr
cd ../sub-ca
openssl ca -config sub-ca.conf -extensions server_cert -days 365 -notext -in ../server/csr/server.csr -out ../server/certs/server.crt


#concatenating sub-ca certificate and server certificate together
cd ../server/certs
cat server.crt ../../sub-ca/certs/sub-ca.crt > chained.crt

 

#start server instance with "openssl s_server" command
echo "192.168.34.10 www.example.com" >> /etc/hosts
ping  www.example.com
cd ..
openssl s_server -accept 443 -www -key private/server.key -cert certs/server.crt -CAfile ../sub-ca/certs/sub-ca.crt

##in other ssh session
ss -ntl
#make system to turst root ca
yum install ca-certificates
update-ca-trust force-enable
cp ca/root-ca/certs/ca.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust extract

#testing
yum install nginx -y
mkdir /var/www
echo hello > /var/www/index.html
cat << EOF >/etc/nginx/conf.d/openssl_test.conf
 server {
        listen       443 ssl http2;
        listen       [::]:443 ssl http2;
        server_name  wwww.example.com;


        ssl_protocols TLSv1.2;
        ssl_certificate "/root/ca/server/certs/chained.crt";
        ssl_certificate_key "/root/ca/server/private/server.key";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;

        location / {
            root /var/www/;
            index index.html index.htm;


        }

    }
EOF
nignx -s reload
curl https://www.example.com

   

