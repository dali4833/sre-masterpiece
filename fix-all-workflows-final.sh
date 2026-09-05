#!/bin/bash

SERVICES=("carts" "front-end" "orders" "payment" "queue-master" "shipping" "user")

for service in "${SERVICES[@]}"; do
    echo "Fixing $service workflow..."
    workflow=".github/workflows/${service}-ci.yml"
    
    cat > "$workflow" << 'WORKFLOWEOF'
name: SERVICE CI/CD

on:
  push:
    branches: [ main ]
    paths:
      - 'local-dev/sock-shop/src/SERVICE/**'

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}/SERVICE

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      packages: write

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: local-dev/sock-shop/src/SERVICE
          push: true
          tags: |
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
            ghcr.io/${{ github.repository }}/SERVICE:v1.0.0

      - name: Update manifest
        run: |
          cd local-dev/kubernetes/sock-shop/manifests
          sed -i "s|image: weaveworksdemos/SERVICE:.*|image: ghcr.io/${{ github.repository }}/SERVICE:${{ github.sha }}|g" SERVICE-dep.yaml

      - name: Commit and push manifest update
        run: |
          git config --global user.name "GitHub Actions"
          git config --global user.email "actions@github.com"
          cd local-dev/kubernetes/sock-shop/manifests
          git add SERVICE-dep.yaml
          git commit -m "Update SERVICE image to ${{ github.sha }}" || echo "No changes to commit"
          git push
WORKFLOWEOF

    # Replace SERVICE with actual service name
    sed -i "s/SERVICE/${service}/g" "$workflow"
    
    echo "✅ $service workflow fixed!"
done

echo "🎉 All workflows fixed!"
