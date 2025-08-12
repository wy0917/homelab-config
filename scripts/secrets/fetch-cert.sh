#!/bin/bash

# Usage: ./fetch-cert.sh <cluster-name>
# Example: ./fetch-cert.sh homelab

set -euo pipefail

CLUSTER=$1

if [ -z "$CLUSTER" ]; then
    echo "Usage: $0 <cluster-name>"
    exit 1
fi

# Directory structure
BASE_DIR="$(dirname "$0")/../.."
CERT_DIR="${BASE_DIR}/clusters/certificates/${CLUSTER}"

# Ensure certificate directory exists
mkdir -p "$CERT_DIR"

echo "Fetching certificate for cluster: $CLUSTER"
kubeseal --fetch-cert \
    --controller-name=sealed-secrets-controller \
    --controller-namespace=kube-system \
    > "${CERT_DIR}/sealed-secrets-cert.pem"

echo "Certificate saved to: ${CERT_DIR}/sealed-secrets-cert.pem"
