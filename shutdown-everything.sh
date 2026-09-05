#!/bin/bash
# ============================================
# SRE-MASTERPIECE COMPLETE SHUTDOWN SCRIPT
# ============================================

echo "🚀 SRE-Masterpiece Shutdown Script"
echo "==================================="
echo "This will shut down ALL resources:"
echo "  - Kubernetes cluster (k3d)"
echo "  - Docker containers"
echo "  - All pods and services"
echo ""
read -p "⚠️  Are you sure? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Shutdown cancelled."
    exit 1
fi

echo ""
echo "============================================"
echo "1. 📦 Shutting down Kubernetes cluster"
echo "============================================"
if k3d cluster list | grep -q "sre-masterpiece"; then
    echo "✅ Cluster 'sre-masterpiece' found. Deleting..."
    k3d cluster delete sre-masterpiece
    echo "✅ Cluster deleted."
else
    echo "ℹ️  No cluster found."
fi

echo ""
echo "============================================"
echo "2. 🐳 Stopping all Docker containers"
echo "============================================"
if [ "$(docker ps -aq)" ]; then
    echo "Stopping all containers..."
    docker stop $(docker ps -aq) 2>/dev/null || true
    echo "Removing all containers..."
    docker rm $(docker ps -aq) 2>/dev/null || true
    echo "✅ All containers stopped and removed."
else
    echo "ℹ️  No containers found."
fi

echo ""
echo "============================================"
echo "3. 🗑️  Cleaning up Docker volumes"
echo "============================================"
if [ "$(docker volume ls -q)" ]; then
    echo "Removing all volumes..."
    docker volume rm $(docker volume ls -q) 2>/dev/null || true
    echo "✅ Volumes removed."
else
    echo "ℹ️  No volumes found."
fi

echo ""
echo "============================================"
echo "4. 🧹 Cleaning up Docker networks"
echo "============================================"
if [ "$(docker network ls -q | grep -v -E 'bridge|host|none')" ]; then
    echo "Removing custom networks..."
    docker network rm $(docker network ls -q | grep -v -E 'bridge|host|none') 2>/dev/null || true
    echo "✅ Custom networks removed."
else
    echo "ℹ️  No custom networks found."
fi

echo ""
echo "============================================"
echo "5. 🧼 Cleaning up Docker system"
echo "============================================"
echo "Running docker system prune..."
docker system prune -af
echo "✅ Docker system cleaned."

echo ""
echo "============================================"
echo "6. 📝 Final Status Check"
echo "============================================"
echo "Docker containers:"
docker ps -a || echo "✅ No containers running"
echo ""
echo "K3d clusters:"
k3d cluster list || echo "✅ No clusters running"
echo ""

echo "============================================"
echo "✅ SHUTDOWN COMPLETE!"
echo "============================================"
echo ""
echo "📊 Summary of what was cleaned:"
echo "  ✅ Kubernetes cluster deleted"
echo "  ✅ All Docker containers removed"
echo "  ✅ All Docker volumes cleaned"
echo "  ✅ Custom networks removed"
echo "  ✅ Docker system pruned"
echo ""
echo "💡 To restart the cluster:"
echo "  k3d cluster create sre-masterpiece --agents 2"
echo "  kubectl apply -f local-dev/kubernetes/sock-shop/manifests -n sock-shop"
echo ""
