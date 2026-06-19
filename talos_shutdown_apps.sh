#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define console output colors
REDBOLD='\033[1;31m'
GREENBOLD='\033[1;32m'
BLUEBOLD='\033[1;34m'
YELLOWBOLD='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUEBOLD}====================================================${NC}"
echo -e "${BLUEBOLD}       Stopping All Apps                            ${NC}"
echo -e "${BLUEBOLD}====================================================${NC}"

/home/brenden/talos/talos_shutdown_actual.sh
/home/brenden/talos/talos_shutdown_homer.sh
