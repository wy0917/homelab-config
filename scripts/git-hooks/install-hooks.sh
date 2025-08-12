#!/bin/bash

# Install git hooks
HOOK_DIR="$(git rev-parse --git-dir)/hooks"
SCRIPT_DIR="$(dirname "$0)"

# Create pre-commit hook
cat > "${HOOK_DIR}/pre-commit" << 'EOF'
#!/bin/bash

# Get the project root directory
PROJECT_ROOT=$(git rev-parse --show-toplevel)

# Check if any sealed secrets are being committed
if git diff --cached --name-only | grep -q "sealed-secrets/.*\.yaml"; then
    echo "Validating sealed secrets..."
    
    # Find all modified apps and their environments
    git diff --cached --name-only | grep "app/.*/overlays/.*/clusters/.*/sealed-secrets/" | while read -r file; do
        # Extract app, environment, and cluster from path
        app_name=$(echo "$file" | awk -F'/' '{print $2}')
        env=$(echo "$file" | awk -F'/' '{print $4}')
        cluster=$(echo "$file" | awk -F'/' '{print $6}')
        
        # Run validation
        if ! "${PROJECT_ROOT}/scripts/secrets/validate-secrets.sh" "$app_name" "$env" "$cluster"; then
            echo "Error: Sealed secrets validation failed for $app_name ($env/$cluster)"
            exit 1
        fi
    done
fi

exit 0
EOF

# Make the hook executable
chmod +x "${HOOK_DIR}/pre-commit"

echo "Git hooks installed successfully!"
