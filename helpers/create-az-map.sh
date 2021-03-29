#!/usr/bin/env bash

set -euo pipefail

AZS="$(az provider list --query "[?namespace=='Microsoft.Compute'].resourceTypes[] | [?resourceType=='virtualMachineScaleSets'].zoneMappings[]" | \
    # Remove entries with empty zones
    jq '[ .[] | select(.zones | length > 0) ]' | \
    # Downcase, remove spaces and add - to the end of the location
    # The - is required to prevent contains() to match similar entries
    # e.g. contains('eastus','eastus2')==true however contains('eastus-','eastus2-')==false
    jq '. | .[].location |= ascii_downcase | .[].location |= gsub( " "; "") | .[].location |= . + "-"' | \
    # Convert to raw text
    jq -Rs . | \
    # Remove first "
    cut -c 2- | \
    # Remove last "
    head -c-2 | \
    # Remove \n
    sed -r 's|\\n||g' | \
    # Remove space*"
    sed -r 's| *||g')"

STR_START="[map(coalesce(first(filter(parse('"
STR_END="'), (item) => contains(item.location, concat(location(), '-')))), parse('{\\\"zones\\\":[]}')).zones, (zone) => parse(concat('{\\\"label\\\":\\\"', zone, '\\\",\\\"value\\\":\\\"', zone, '\\\"}')))]"

printf '%s%s%s' "${STR_START}" "${AZS}" "${STR_END}"
