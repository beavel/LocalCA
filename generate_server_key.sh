#! /bin/bash

while getopts ":c:o:" opt; do
  case ${opt} in
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
if [[ -z $OPENSSL_CONFIG ]]; then
    OPENSSL_CONFIG=configs/openssl_req.cnf
fi

if [[ -z $SERVER_REQ ]]; then
    SERVER_REQ=tls/ecc_key.csr
fi

# Files
SERVER_KEY=tls/private/ecc_key.pem

mkdir -p tls/certs tls/private

openssl ecparam -genkey -name prime256v1 -out ${SERVER_KEY}

openssl req -new -sha256 -key ${SERVER_KEY} -out ${SERVER_REQ} -config ${OPENSSL_CONFIG}