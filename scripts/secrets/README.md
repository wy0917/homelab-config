# Secret Management Scripts

These scripts help manage secrets across multiple applications and clusters.

## Scripts

### seal-secrets.sh
Seals raw secrets for specific applications and clusters.

```bash
# Usage
./seal-secrets.sh <app-name> <environment> <cluster-name>

# Example
./seal-secrets.sh gitea prod homelab
```

### validate-secrets.sh
Validates both raw and sealed secrets.

```bash
# Usage
./validate-secrets.sh <app-name> <environment> <cluster-name>

# Example
./validate-secrets.sh gitea prod homelab
```

## Directory Structure

The scripts expect the following directory structure:
```
.
├── app/
│   └── <app-name>/
│       ├── secrets/
│       │   └── <env>/
│       │       └── <cluster>/
│       │           └── *.yaml
│       └── overlays/
│           └── <env>/
│               └── clusters/
│                   └── <cluster>/
│                       └── sealed-secrets/
└── clusters/
    └── certificates/
        └── <cluster>/
            └── sealed-secrets-cert.pem
```

## Security Notes

- Raw secrets are never committed to git
- Each cluster has its own sealed secrets
- Validation ensures proper secret format and content
