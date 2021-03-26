#!/usr/bin/env bash

set -euo pipefail

CUSTOM_DATA="$(base64 --wrap=0 < "${1}")"

TEMPLATE="$(jq --indent 4 --arg customData "${CUSTOM_DATA}" '.variables.customData = $customData' "${2}")"

echo "$TEMPLATE" > "${2}"

echo Done.
