#!/bin/bash

# Usage: ./seal-secrets.sh <app-name> <environment> <cluster-name>
# Example: ./seal-secrets.sh gitea prod homelab

set -euo pipefail

APP_NAME=$1
ENV=$2
CLUSTER=$3

if [ -z "$APP_NAME" ] || [ -z "$ENV" ] || [ -z "$CLUSTER" ]; then
    echo "Usage: $0 <app-name> <environment> <cluster-name>"
    exit 1
fi

# Directory structure
BASE_DIR="$(dirname "$0")/../.."
RAW_SECRETS_DIR="${BASE_DIR}/app/${APP_NAME}/secrets/${ENV}/${CLUSTER}"
SEALED_DIR="${BASE_DIR}/app/${APP_NAME}/overlays/${ENV}/clusters/${CLUSTER}/sealed-secrets"
CERT_PATH="${BASE_DIR}/clusters/certificates/${CLUSTER}/sealed-secrets-cert.pem"

# Ensure directories exist
mkdir -p "$SEALED_DIR"

# Check if certificate exists
if [ ! -f "$CERT_PATH" ]; then
    echo "Error: Certificate not found at $CERT_PATH"
    echo "Please ensure the certificate exists in the clusters/certificates/${CLUSTER}/ directory"
    exit 1
fi

# Create sealed secrets from raw secrets
for raw_secret in "${RAW_SECRETS_DIR}"/*.yaml; do
    if [ -f "$raw_secret" ]; then
        filename=$(basename "$raw_secret")
        sealed_name="${filename}"
        
        echo "Sealing secret: $filename for ${APP_NAME}/${ENV} using cluster: $CLUSTER"
        kubeseal --format yaml \
            --cert="$CERT_PATH" \
            --scope cluster-wide \
            < "$raw_secret" \
            > "${SEALED_DIR}/${sealed_name}"
    fi
done

echo "Done sealing secrets for ${APP_NAME}/${ENV} environment using $CLUSTER cluster certificate"
