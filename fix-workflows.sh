#!/bin/bash

# Fix all workflows to use cd approach
for workflow in .github/workflows/*-ci.yml; do
    echo "Fixing $workflow..."
    
    # Remove the incorrect path duplication
    sed -i 's|local-dev/kubernetes/sock-shop/manifests/local-dev/kubernetes/sock-shop/manifests/|local-dev/kubernetes/sock-shop/manifests/|g' "$workflow"
    
    # If there's a cd command, ensure sed uses simple path
    sed -i 's|sed -i "s|\(.*\)" local-dev/kubernetes/sock-shop/manifests/\(.*\)\.yaml|sed -i "s|\1" \2.yaml|g' "$workflow"
    sed -i 's|git add local-dev/kubernetes/sock-shop/manifests/\(.*\)\.yaml|git add \1.yaml|g' "$workflow"
done

echo "✅ All workflows fixed!"
