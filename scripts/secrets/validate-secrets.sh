#!/bin/bash

# Usage: ./validate-secrets.sh <app-name> <environment> <cluster-name>
# Example: ./validate-secrets.sh gitea prod homelab

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

[Previous validation script content with updated paths...]
