#!/usr/bin/env bash

set -xeuo pipefail

mkdir -p ./tmp

find "${1}" -maxdepth 1 -type f | zip -j "./tmp/${1##*/}.zip" -@
