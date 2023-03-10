#!/bin/bash

set -e

ROOT_CERT="${ROOT_CERT:=local-ca}"

CERT_NAME="${CERT_NAME:=server}"
CERT_BITS="${CERT_BITS:=2048}"
CERT_DAYS="${CERT_DAYS:=365}"

CERT_EMAIL="${CERT_EMAIL:=admin@local.email}"
CERT_COUNTRY="${CERT_COUNTRY:=NL}"
CERT_STATE="${CERT_STATE:=Utrecht}"
CERT_CITY="${CERT_CITY:=Utrecht}"
CERT_ORG="${CERT_ORG:=Organisation}"

ALT_DNS="${ALT_DNS:=localhost}"
ALT_IP="${ALT_IP:=127.0.0.1}"

# -----------------------------------------------------------------------------
# CREATE OPENSSL CONFIGURATION
# -----------------------------------------------------------------------------

cat > ${CERT_NAME}.cnf <<-EOF
[ req ]
#default_bits = 2048
#prompt = no
#default_md = sha256
req_extensions = request_ext
distinguished_name = dn

[ dn ]

[ request_ext ]
subjectAltName = @alt_names

[ server_ext ]
nsCertType = server
subjectAltName = @alt_names
basicConstraints = critical, CA:FALSE
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = critical, serverAuth
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer:always

[ alt_names ]
DNS.1 = ${ALT_DNS}
IP.1 = ${ALT_IP}
EOF

# -----------------------------------------------------------------------------
# CREATE SIGNED CERTIFICATE
# -----------------------------------------------------------------------------

# Create private key
openssl genrsa -out ${CERT_NAME}.key ${CERT_BITS}

# Create certificate request
openssl req -new -sha256 -nodes \
	-subj "/emailAddress=${CERT_EMAIL}/C=${CERT_COUNTRY}/ST=${CERT_STATE}/L=${CERT_CITY}/O=${CERT_ORG}/CN=${ALT_DNS}" \
	-key ${CERT_NAME}.key \
	-out ${CERT_NAME}.csr \
	-config ${CERT_NAME}.cnf

# Show certificate sign request contents
openssl req -text -noout -verify -in ${CERT_NAME}.csr

# Sign the certificate
openssl x509 -req -sha256 -days ${CERT_DAYS} \
	-CA ${ROOT_CERT}.crt -CAkey ${ROOT_CERT}.key -CAcreateserial \
	-extensions server_ext -extfile ${CERT_NAME}.cnf \
	-in ${CERT_NAME}.csr \
	-out ${CERT_NAME}.crt

# Show certificate contents
openssl x509 -in ${CERT_NAME}.crt -text -noout
