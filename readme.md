# Create sel-signed root certificates and signed certificates

## Examples

# Root ca
CERT_NAME=example-root-ca ./mk-root-cert.sh

# Signed certificate
CERT_NAME=example ROOT_CERT=example-root-ca ALT_DNS=myserver ALT_IP=192.168.56.101 ./mk-signed-cert.sh

## Install (Ubuntu)
sudo apt-get install -y ca-certificates
sudo cp my-root-ca.crt /usr/local/share/ca-certificates
sudo update-ca-certificates
