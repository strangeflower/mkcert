#!/bin/bash

set -e

CERT_NAME="${CERT_NAME:=local-ca}"
CERT_BITS="${CERT_BITS:=4096}"
CERT_DAYS="${CERT_EXP:=3650}"

CERT_EMAIL="${CERT_EMAIL:=admin@local.email}"
CERT_COUNTRY="${CERT_COUNTRY:=NL}"
CERT_STATE="${CERT_STATE:=Utrecht}"
CERT_CITY="${CERT_CITY:=Utrecht}"
CERT_ORG="${CERT_ORG:=Organisation}"

# -----------------------------------------------------------------------------
# CREATE ROOT CERTIFICATE
# -----------------------------------------------------------------------------

# Create private key
openssl genrsa -out ${CERT_NAME}.key ${CERT_BITS}

# Create self-signed certificate
openssl req -x509 -new -sha256 -nodes -days ${CERT_DAYS} \
	-subj "/emailAddress=${CERT_EMAIL}/C=${CERT_COUNTRY}/ST=${CERT_STATE}/L=${CERT_CITY}/O=${CERT_ORG}/CN=${CERT_NAME}" \
	-key ${CERT_NAME}.key \
	-out ${CERT_NAME}.crt

# Show certificate contents
openssl x509 -text -noout -in ${CERT_NAME}.crt
