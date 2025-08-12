# Cluster Configurations

This directory contains cluster-specific configurations and certificates.

## Directory Structure

```
clusters/
├── certificates/          # Cluster-specific certificates
│   ├── prod-cluster/      # Production cluster certificates
│   │   └── sealed-secrets-cert.pem
│   └── staging-cluster/   # Staging cluster certificates
│       └── sealed-secrets-cert.pem
└── README.md
```

## Setting Up a New Cluster

1. Create a new directory for your cluster certificates:
```bash
mkdir -p clusters/certificates/your-cluster-name
```

2. Fetch the cluster's sealed-secrets certificate:
```bash
kubeseal --fetch-cert \
  --controller-name=sealed-secrets-controller \
  --controller-namespace=kube-system \
  > clusters/certificates/your-cluster-name/sealed-secrets-cert.pem
```

3. Create cluster-specific configurations in app overlays:
```bash
mkdir -p app/gitea/overlays/prod/clusters/your-cluster-name
```

## Security Notes

- Certificates in this directory are public keys and safe to commit
- Private keys remain in the clusters
- Raw secrets should NEVER be committed (stored in secrets/ directory, which is gitignored)
- Each cluster should have its own sealed secrets

## Certificate Management

- Backup the sealed-secrets controller private key from each cluster
- Document certificate rotation procedures
- Keep certificate metadata (expiry dates, rotation schedule)

## ArgoCD Integration

Example Application CR:
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gitea-prod-cluster1
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/your-org/your-repo.git'
    path: app/gitea/overlays/prod/clusters/cluster1
    targetRevision: HEAD
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: prod
```

## Maintenance

- Regularly rotate certificates
- Keep cluster configurations up to date
- Document cluster-specific requirements
- Maintain backup procedures