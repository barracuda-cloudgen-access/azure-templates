#!/usr/bin/env bash

set -xeuo pipefail

base64 --wrap=0 < "${1}"
