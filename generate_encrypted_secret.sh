#! /bin/bash

PASSWORD_DIR=pass

mkdir -p ${PASSWORD_DIR}

read -s -p 'Cert password:' MY_SECRET && echo
echo "${MY_SECRET}" > ${PASSWORD_DIR}/tmp_pass

openssl enc -aes-256-ctr -pbkdf2 -iter 100101 -salt -in ${PASSWORD_DIR}/tmp_pass -out ${PASSWORD_DIR}/cert_pass.enc
rm ${PASSWORD_DIR}/tmp_pass