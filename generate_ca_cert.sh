#! /bin/bash

while getopts ":c:i" opt; do
  case ${opt} in
    c) CA_CONFIG=$(readlink -f "$OPTARG")
    ;;
    i) INITIALIZE=true
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac
done

# Configure defaults for inputs
if [[ -z $CA_CONFIG ]]; then
  CA_CONFIG=configs/openssl_ca.cnf
fi

if [ "$INITIALIZE" = "true" ]; then
  # Skip settings these in cases where we don't want to init
  # Tracking files; Need to match what is in the openssl config used
  SERIAL_FILE=tls/ca/serials
  INDEX_FILE=tls/ca/index.txt
fi

# Inputs
PASSWORD_DIR=pass
CA_PASSWORD=${PASSWORD_DIR}/cert_pass.enc

# CA Files
CA_KEY=tls/ca/private/ca_ecc_key.pem
CA_KEY_ENCRYPTED=tls/ca/private/ca_ecc_key.enc
CA_CERT=tls/ca/certs/ca_ecc_cert.pem

mkdir -p tls/ca/certs tls/ca/private

if [[ -n $SERIAL_FILE ]]; then
  # Generate serial file for tracking last serial used; required to be unique and in hex
  echo 01 > ${SERIAL_FILE}
fi

if [[ -n $INDEX_FILE ]]; then
  # Generate index file for tracking issued certificates
  touch ${INDEX_FILE}
fi

# Check available curves, if needed
# openssl ecparam -list_curves
# Create key for cert: ECC
openssl ecparam -genkey -name prime256v1 -out ${CA_KEY}

# Encrypt key
openssl ec -aes-256-ctr -in ${CA_KEY} -passout file:${CA_PASSWORD} -out ${CA_KEY_ENCRYPTED}

# # Generate certificate
openssl req -new -x509 -days 3650 -config ${CA_CONFIG} -extensions v3_ca -key ${CA_KEY_ENCRYPTED} -out ${CA_CERT} -passin file:${CA_PASSWORD}

