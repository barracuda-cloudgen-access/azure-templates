#!/bin/bash

set -euo pipefail

echo "RateLimitBurst=10000" >> /etc/systemd/journald.conf
systemctl restart systemd-journald.service

yum -y install curl jq

AZURE_TOKEN="$(curl -H Metadata:true \
    "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net" | \
    jq -r .access_token)"

IFS=";" read -r -a TAGS <<< "$(curl -H Metadata:true \
    "http://169.254.169.254/metadata/instance/compute?api-version=2018-10-01" | \
    jq -r .tags)"

for TAG in "${TAGS[@]}"; do
    if [[ "${TAG}" =~ ^KeyVault ]]; then
        KEY_VAULT_NAME="${TAG#*:}"
    fi
done

CGA_TOKEN="$(curl -H "Authorization: Bearer ${AZURE_TOKEN}" \
    "https://${KEY_VAULT_NAME}.vault.azure.net/secrets/cga-proxy-token?api-version=2016-10-01" | \
    jq -r .value)"

curl -sL "https://url.fyde.me/install-fyde-proxy-linux" | bash -s -- -u -p "443" -z \
    -t "${CGA_TOKEN}"
