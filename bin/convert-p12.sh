#!/usr/bin/env bash

IN=${1:-${CERT_PATH}}
OUT=$(dirname ${IN})/$(basename ${IN} .p12)

if [[ -z "${CERT_PASS}" ]]; then
    read -sp "Certificate Password:" CERT_PASS
    export CERT_PASS
fi

openssl pkcs12 -password env:CERT_PASS -nokeys -in ${IN} -out ${OUT}.crt
openssl pkcs12 -password env:CERT_PASS -nocerts -nodes -in ${IN} -out ${OUT}.key
openssl pkcs12 -password env:CERT_PASS -nodes -clcerts -in ${IN}  -out ${OUT}.pem

openssl pkcs12 -passin env:CERT_PASS -nodes -nokeys -in ${IN} -out client.crt
openssl pkcs12 -passin env:CERT_PASS -nodes -nocerts -in ${IN} -out client.key
openssl pkcs12 -passin env:CERT_PASS -nodes -clcerts -in ${IN}  -out client.pem
openssl pkcs12 -export -in client.crt -inkey client.key -out client.p12 -passout pass:client
