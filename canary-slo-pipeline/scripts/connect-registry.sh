#!/bin/bash
set -e

# For Docker Desktop on WSL2, use host.docker.internal
REGISTRY_HOST="host.docker.internal"

echo "Using registry at: $REGISTRY_HOST:5000"

# Add registry to Kind nodes
for node in $(kind get nodes --name canary-prod); do
    echo "Configuring $node..."
    docker exec "$node" bash -c "
        # Get the host IP
        HOST_IP=\$(ip route | grep default | awk '{print \$3}')
        echo \"\$HOST_IP registry host.docker.internal\" >> /etc/hosts
    "
done

echo "✅ Registry connected to Kind cluster!"
