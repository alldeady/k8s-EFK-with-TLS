#!/bin/bash

mkdir certs
cd certs

# Generate Root Key rootCA.key with 2048
openssl genrsa -passout pass:"$1" -des3 -out rootCA.key 2048

# Generate Root PEM (rootCA.pem)
openssl req -passin pass:"$1" -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=Local Certificate"  \
-x509 -new -nodes -key rootCA.key -sha256 -days 3000 -out rootCA.pem

# Generate ES Cert
openssl req -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=localhost"  \
-new -sha256 -nodes -out es.csr -newkey rsa:2048 -keyout es.key

openssl x509 -req -passin pass:"$1" -in es.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out es.crt \
-days 3000 -sha256

# Generate Kib Cert
openssl req -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=localhost"  \
-new -sha256 -nodes -out kib.csr -newkey rsa:2048 -keyout kib.key

openssl x509 -req -passin pass:"$1" -in kib.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out kib.crt \
-days 3000 -sha256

# Generate Fluent-bit Cert
openssl req -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=localhost"  \
-new -sha256 -nodes -out fluent-bit.csr -newkey rsa:2048 -keyout fluent-bit.key

openssl x509 -req -passin pass:"$1" -in fluent-bit.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out fluent-bit.crt \
-days 3000 -sha256

# # Generate Grafana Cert
# openssl req -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=localhost"  \
# -new -sha256 -nodes -out grafana.csr -newkey rsa:2048 -keyout grafana.key

# openssl x509 -req -passin pass:"$1" -in fluent-bit.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out grafana.crt \
# -days 3000 -sha256
