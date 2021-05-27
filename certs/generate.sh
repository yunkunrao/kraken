#! /bin/bash

openssl genrsa -out kraken.key 4096

openssl req -sha512 -new \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=yourdomain.com" \
    -key kraken.key \
    -out kraken.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=test
EOF

openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA /root/harbor_pro/certs/ca.crt -CAkey /root/harbor_pro/certs/ca.key -CAcreateserial \
    -in kraken.csr \
    -out kraken.crt

mv kraken.crt ./tls.crt
mv kraken.key ./tls.key

kubectl create secret tls kraken-secret --cert=tls.crt --key=tls.key -n kraken

