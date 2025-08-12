# Kubernetes Deployment

This repository is a Kubernetes configurations for homelab setup.

## Directory Structure

```
.
├── app/
│   └── xxxxx/                    # An application
│       ├── base/                 # Base configuration
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── pv.yaml
│       │   └── kustomization.yaml
│       ├── overlays/             # Environment overlays
│       │   └── prod/
│       │       └── clusters/     # Cluster-specific configs
│       │           └── homelab/  # Example cluster
│       └── secrets/              # Raw secrets (not in git)
├── clusters/                     # Cluster configurations
│   └── certificates/             # Cluster certificates
├── scripts/                      # Utility scripts
│   ├── secrets/                  # Secret management
│   │   ├── fetch-cert.sh         # Fetch cluster certificates
│   │   ├── seal-secrets.sh       # Seal secrets for clusters
│   │   └── validate-secrets.sh   # Validate secrets
│   └── git-hooks/                # Git hooks setup
└── README.md

```

## Prerequisites

- Kubernetes cluster
- kubectl
- kubeseal (Sealed Secrets)
- kustomize
- ArgoCD (optional)

## Setup Instructions

1. **Prepare Cluster**:
   ```bash
   # Install Sealed Secrets Controller
   kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.24.5/controller.yaml
   ```

2. **Configure Cluster Certificate**:
   ```bash
   # Fetch cluster certificate
   ./scripts/secrets/fetch-cert.sh homelab
   ```

3. **Create and Manage Secrets**:
   ```bash
   # First, create your raw secret in:
   # app/xxxx/secrets/{env}/{cluster}/postgres-secret.yaml

   # Then seal it (creates sealed secret in overlays)
   ./scripts/secrets/seal-secrets.sh xxxx prod cluster-name

   # Validate secrets
   ./scripts/secrets/validate-secrets.sh xxxx prod cluster-name
   ```

4. **Deploy**:
   ```bash
   # Direct deployment
   kubectl apply -k app/xxxx/overlays/prod/clusters/cluster-name

   # Or via ArgoCD
   kubectl apply -f path/to/argocd/application.yaml
   ```

## Scripts

### Secret Management
- `fetch-cert.sh <cluster-name>`: Fetch public key from a cluster
- `seal-secrets.sh <app-name> <env> <cluster>`: Seal secrets for a specific app and cluster
- `validate-secrets.sh <app-name> <env> <cluster>`: Validate raw and sealed secrets

### Git Hooks
```bash
# Install git hooks
./scripts/git-hooks/install-hooks.sh
```

## Adding a New Cluster

1. Fetch cluster certificate:
   ```bash
   ./scripts/secrets/fetch-cert.sh new-cluster
   ```

2. Create cluster directory:
   ```bash
   mkdir -p app/xxxx/overlays/prod/clusters/new-cluster/{sealed-secrets,}
   ```

3. Create cluster configurations:
   - Copy and modify from existing cluster:
     - local-storage.yaml
     - node-selector.yaml
     - kustomization.yaml

4. Create and seal secrets:
   ```bash
   # Create raw secret
   mkdir -p app/xxxx/secrets/prod/new-cluster
   # Edit app/xxxx/secrets/prod/new-cluster/postgres-secret.yaml

   # Seal secrets
   ./scripts/secrets/seal-secrets.sh xxxx prod new-cluster
   ```

## Security

- Raw secrets are never committed (stored in app/*/secrets/)
- Only sealed secrets are committed to git
- Each cluster has its own sealed secrets
- Certificates in clusters/certificates are public keys

## Maintenance

- Regular secret rotation
- Certificate management
- Storage monitoring
- Backup procedures

## Contributing

1. Create feature branch
2. Make changes
3. Run validations
4. Submit PR

## License

MIT License
