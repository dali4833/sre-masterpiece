# 🚀 SRE Masterpiece – Multi-Cloud Platform

![Status](https://img.shields.io/badge/Status-Local%20Development-green)
![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.35.5-blue)
![ArgoCD](https://img.shields.io/badge/ArgoCD-v2.14.3-orange)

## 🎯 Project Overview

Production-grade SRE platform built with modern DevOps practices. Currently running locally with k3d, designed to be replicated across AWS, Azure, and GCP.

## ✅ What's Working (Local Development)

- ✅ **Kubernetes Cluster** (k3d) - 3 nodes (1 control-plane, 2 workers)
- ✅ **Sock Shop Application** - 11 microservices running
- ✅ **ArgoCD** - GitOps continuous deployment
- ✅ **GitHub Integration** - Source of truth
- ✅ **Prometheus + Grafana** - Metrics and monitoring
- ✅ **Loki** - Log aggregation
- ✅ **Alert Rules** - Automated alerting
- ✅ **GitOps Workflow** - Auto-deploy on git push

## 🏗️ Architecture
Developer → VS Code → Git Push → GitHub → ArgoCD → Kubernetes (k3d)
↓
Sock Shop (11 services)
↓
Prometheus → Grafana
↓
Loki

text

## 📂 Project Structure
sre-masterpiece/
├── local-dev/
│ ├── kubernetes/
│ │ └── sock-shop/
│ │ └── manifests/ # K8s deployment manifests
│ ├── sock-shop/
│ │ ├── microservices-demo/ # Deployment configs
│ │ └── src/ # Source code (7 microservices)
│ ├── observability/
│ │ ├── prometheus/
│ │ │ └── rules/ # Alert rules
│ │ ├── grafana/
│ │ └── loki/
│ └── gitops/
│ └── argocd/
│ └── applications/ # ArgoCD app definitions
├── aws/ # AWS configs (coming)
├── azure/ # Azure configs (coming)
├── gcp/ # GCP configs (coming)
├── ci-cd/ # CI/CD pipelines
└── security/ # Security configs


## 🛠️ Technology Stack

| Category | Tools |
|----------|-------|
| **Orchestration** | Kubernetes (k3d) |
| **Application** | Sock Shop (Weaveworks) |
| **GitOps** | ArgoCD |
| **Monitoring** | Prometheus + Grafana |
| **Logging** | Loki |
| **Version Control** | Git + GitHub |
| **Container Runtime** | Docker |

## 🚀 Quick Start

### Prerequisites
- Docker
- k3d
- kubectl
- Helm

### Setup Steps

1. **Create Cluster**
```bash
k3d cluster create sre-masterpiece --agents 2

Deploy Sock Shop

bash
kubectl create namespace sock-shop
kubectl apply -f local-dev/kubernetes/sock-shop/manifests -n sock-shop
Access ArgoCD

bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Open https://localhost:8080
Access Sock Shop

bash
kubectl port-forward svc/front-end -n sock-shop 8079:80
# Open http://localhost:8079
Access Grafana

bash
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
# Open http://localhost:3000 (admin/admin123)
📊 Microservices Architecture
Service	Language	Database
front-end	Node.js	-
catalogue	Go	MySQL
carts	Java	MongoDB
orders	Java	MongoDB
payment	Go	-
shipping	Java	-
user	Go	MongoDB
queue-master	Java	RabbitMQ
session-db	Redis	-
🎯 GitOps Workflow
Developer edits code in VS Code

git push origin main

ArgoCD detects change

ArgoCD auto-syncs to Kubernetes

Application updates automatically

📝 Deployment Log
September 4, 2026
✅ Created k3d cluster (3 nodes)

✅ Deployed Sock Shop (11 microservices)

✅ Set up Prometheus + Grafana

✅ Configured Loki for logs

✅ Installed ArgoCD (v2.14.3)

✅ Connected GitHub repository

✅ Created ArgoCD application

✅ Tested GitOps auto-sync

🌐 Multi-Cloud Roadmap
☑ Local Development (k3d)
□ AWS EKS deployment
□ Azure AKS deployment
□ GCP GKE deployment
□ Service Mesh (Istio)
□ Chaos Engineering (Chaos Mesh)
□ Security Scanning (Trivy)
□ Secrets Management (Vault)
👤 Author
@dali4833

text

**Copy ALL of this, replace your README.md content, save, and push!** 🚀