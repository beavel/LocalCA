#! /bin/bash

while getopts ":a:c:o:" opt; do
  case ${opt} in
    a) ALGORITHM=$OPTARG
    ;;
    c) OPENSSL_CONFIG=$(readlink -f "$OPTARG")
    ;;
    o) SERVER_REQ=$OPTARG
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac
done

# Configure defaults for inputs
if [[ -z $ALGORITHM ]]; then
    ALGORITHM=ECC
fi

if [ "$ALGORITHM" = "ECC" ]; then
  KEY_NAME=ecc_key
fi

if [ "$ALGORITHM" = "RSA" ]; then
  KEY_NAME=rsa_key
fi

if [[ -z $OPENSSL_CONFIG ]]; then
    OPENSSL_CONFIG=configs/openssl_req.cnf
fi

if [[ -z $SERVER_REQ ]]; then
    SERVER_REQ=tls/${KEY_NAME}.csr
fi

# Files
SERVER_KEY=tls/private/${KEY_NAME}.pem

mkdir -p tls/certs tls/private

if [ "$ALGORITHM" = "ECC" ]; then
  openssl ecparam -genkey -name prime256v1 -out ${SERVER_KEY}
fi

if [ "$ALGORITHM" = "RSA" ]; then
  openssl genrsa -out ${SERVER_KEY} 4096
fi

openssl req -new -sha256 -key ${SERVER_KEY} -out ${SERVER_REQ} -config ${OPENSSL_CONFIG}