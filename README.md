# CA Generation Process
1. Run `generate_encrypted_secret.sh` to create encrypted credentials to be used by CA process
2. Run `generate_ca_cert.sh -i` to generate CA cert, key, and tracking info

# Signing
1. Generate CSR where required. `generate_server_key.sh` can be used if desired.
2. Run `sign_csr.sh` to sign a CSR.

# Converting results

## Create encrypted PKCS8 PEM Key
```bash
# Securely read password
read -s -p 'Cert password:' TMP_SECRET && echo
export KEY_SECRET=$TMP_SECRET
# Convert and encypt using environment variable
openssl pkcs8 -in tls/private/ecc_key.pem -topk8 -out tls/private/ecc_encrypted.key -passout env:KEY_SECRET
```