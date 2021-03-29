#!/usr/bin/env bash
#
# Copyright (c) 2020-present, Barracuda Networks Inc.
#

# Set error handling
set -euo pipefail

# Functions

function log_entry() {
    local LOG_TYPE="${1:?Needs log type}"
    local LOG_MSG="${2:?Needs log message}"
    local LOG_SEP="=================================================================="

    echo -e "${LOG_SEP}\n$(date "+%Y-%m-%d %H:%M:%S") [$LOG_TYPE] ${LOG_MSG}\n${LOG_SEP}"
}

function get_secret() {
    local TOKEN="${1}"
    local VAULT="${2}"
    local SECRET="${3}"

    curl -s -H "Authorization: Bearer ${TOKEN}" \
        "https://${VAULT}.vault.azure.net/secrets/${SECRET}?api-version=2016-10-01" | \
        jq -r .value
}

log_entry "INFO" "Misc configs"
echo "RateLimitBurst=10000" >> /etc/systemd/journald.conf
systemctl restart systemd-journald.service

log_entry "INFO" "Install support tools"
yum -y install curl jq openssl

log_entry "INFO" "Get instance token"
AZURE_TOKEN="$(curl -s -H Metadata:true \
    "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net" | \
    jq -r .access_token)"

log_entry "INFO" "Get instance tags"
IFS=";" read -r -a TAGS <<< "$(curl -s -H Metadata:true \
    "http://169.254.169.254/metadata/instance/compute?api-version=2018-10-01" | \
    jq -r .tags)"

log_entry "INFO" "Process instance tags"
for TAG in "${TAGS[@]}"; do
    if [[ "${TAG}" =~ ^keyVault ]]; then
        KEY_VAULT_NAME="${TAG#*:}"
    fi
    if [[ "${TAG}" =~ ^haEnabled ]]; then
        HA_ENABLED="${TAG#*:}"
    fi
done

# Try token until it's valid or VMSS replaces the instance
# Needs VMSS identity added to vault (might take a while)
log_entry "INFO" "Get enrollment token"
for (( RUN=1; ;RUN++ )); do
    CGA_TOKEN="$(get_secret "${AZURE_TOKEN}" "${KEY_VAULT_NAME}" cga-proxy-token)"
    if [[ "${CGA_TOKEN:-}" =~ ^http[s]?://[^/]+/proxies/v[0-9]+/enrollment/[0-9a-f-]+\?proxy_auth_token=[^\&]+\&tenant_id=[0-9a-f-]+$ ]]; then
        log_entry "INFO" "Enrollment token is valid"
        break
    fi
    log_entry "INFO" "Retrying enrollment token request from vault in 5 seconds. Attempt ${RUN}"
    sleep 5
done

# Set redis instance when necessary
EXTRA_ARGS=()
if [[ "${HA_ENABLED:-}" == "true" ]]; then

    log_entry "INFO" "HA is enabled"

    log_entry "INFO" "Get Microsoft root CAs"
    # https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-whats-new
    # https://www.digicert.com/kb/digicert-root-certificates.htm
    curl -s https://cacerts.digicert.com/BaltimoreCyberTrustRoot.crt.pem > /etc/ssl/certs/azure-redis-ca.pem
    curl -s https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem  >> /etc/ssl/certs/azure-redis-ca.pem
    # https://www.microsoft.com/pkiops/Docs/Repository.htm
    openssl x509 -inform DER -in \
        <(curl -s "http://www.microsoft.com/pkiops/certs/Microsoft%20RSA%20Root%20Certificate%20Authority%202017.crt" --output -) \
        >> /etc/ssl/certs/azure-redis-ca.pem

    log_entry "INFO" "Get redis secrets"
    EXTRA_ARGS+=("-e" "REDIS_HOST=$(get_secret "${AZURE_TOKEN}" "${KEY_VAULT_NAME}" redis-host)")
    EXTRA_ARGS+=("-e" "REDIS_PORT=$(get_secret "${AZURE_TOKEN}" "${KEY_VAULT_NAME}" redis-port)")
    EXTRA_ARGS+=("-e" "REDIS_AUTH=$(get_secret "${AZURE_TOKEN}" "${KEY_VAULT_NAME}" redis-auth)")
    EXTRA_ARGS+=("-e" "REDIS_SSL=TRUE")

else
    log_entry "INFO" "HA is not enabled"
fi

log_entry "INFO" "Install proxy"
curl -sL "https://url.fyde.me/proxy-linux" | bash -s -- -u -p "443" -z \
    -t "${CGA_TOKEN}" \
    "${EXTRA_ARGS[@]}"

log_entry "INFO" "Harden instance"
curl -sL "https://url.fyde.me/harden-linux" | bash -s --

log_entry "INFO" "Reboot"
shutdown -r now
