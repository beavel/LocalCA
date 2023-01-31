#! /bin/bash


while getopts ":r:o:" opt; do
  case ${opt} in
    o) SERVER_CERT="$OPTARG"
    ;;
    r) SERVER_REQ=$(readlink -f "$OPTARG")
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac
done

# Configure defaults for inputs
if [[ -z $SERVER_REQ ]]; then
    SERVER_REQ=tls/ecc_key.csr
fi

if [[ -z $SERVER_CERT ]]; then
    SERVER_CERT=tls/certs/server.crt
fi

# Inputs
PASSWORD_DIR=pass
CA_PASSWORD=${PASSWORD_DIR}/cert_pass.enc

# CA Files
CA_CONFIG=configs/openssl_ca.cnf
CA_KEY=tls/ca/private/ca_ecc_key.pem
CA_KEY_ENCRYPTED=tls/ca/private/ca_ecc_key.enc
CA_CERT=tls/ca/certs/ca_ecc_cert.pem

# Figure out how to use encrypted key and passin
VALID_DAYS=$((365*5))
openssl ca -keyfile ${CA_KEY_ENCRYPTED} -cert ${CA_CERT} -passin file:${CA_PASSWORD} \
  -in ${SERVER_REQ} -out ${SERVER_CERT} \
  -days ${VALID_DAYS} -config ${CA_CONFIG} \
  -rand_serial

# Working
# openssl ca -keyfile ${CA_KEY} -cert ${CA_CERT} -in ${SERVER_REQ} -out ${SERVER_CERT} -config ${CA_CONFIG}