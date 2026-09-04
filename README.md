<a name="readme-top"></a>

<div align="center">

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

</div>

<br />
<div align="center">
  <h1 align="center">🚀 SRE Masterpiece</h1>

  <p align="center">
    A production-grade multi-cloud SRE platform with GitOps, CI/CD, and full observability!
    <br />
    <a href="#-about-the-project"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="#-getting-started">Getting Started</a>
    ·
    <a href="#-roadmap">Roadmap</a>
    ·
    <a href="#-contributing">Contributing</a>
    ·
    <a href="#-license">License</a>
    ·
    <a href="#-contact">Contact</a>
  </p>
</div>

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#-about-the-project">About The Project</a></li>
    <li><a href="#️-built-with">Built With</a></li>
    <li><a href="#️-architecture">Architecture</a></li>
    <li><a href="#-getting-started">Getting Started</a></li>
    <li><a href="#-usage">Usage</a></li>
    <li><a href="#-roadmap">Roadmap</a></li>
    <li><a href="#-contributing">Contributing</a></li>
    <li><a href="#-license">License</a></li>
    <li><a href="#-contact">Contact</a></li>
    <li><a href="#-acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

## 📖 About The Project

This project is a **production-grade SRE (Site Reliability Engineering) platform** built with modern DevOps practices and GitOps principles. It demonstrates a complete CI/CD pipeline with automated deployments, comprehensive observability, and infrastructure designed for multi-cloud scalability.

### Key Features:

- 🔄 **Full CI/CD Pipeline** - GitHub Actions for all 7 microservices
- 🎯 **GitOps with ArgoCD** - Automated deployments from Git
- 📊 **Complete Observability** - Metrics, logs, and alerting
- 🐳 **Container Registry** - GitHub Container Registry (GHCR)
- 🏗️ **Kubernetes Orchestration** - 3-node cluster with 11 microservices
- 🔐 **Security Ready** - Foundation for Trivy, Vault, OPA

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🛠️ Built With

### Infrastructure & Orchestration
* [![Kubernetes][Kubernetes]][Kubernetes-url]
* [![Docker][Docker]][Docker-url]

### CI/CD & GitOps
* [![GitHub Actions][GitHub-Actions]][GitHub-Actions-url]
* [![ArgoCD][ArgoCD]][ArgoCD-url]
* [![Git][Git]][Git-url]

### Observability
* [![Prometheus][Prometheus]][Prometheus-url]
* [![Grafana][Grafana]][Grafana-url]
* [![Loki][Loki]][Loki-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🏗️ Architecture

```text
Developer → VS Code → Git Push → GitHub Actions (CI)
                                    ↓
                              Build Docker Image
                                    ↓
                              Push to GHCR
                                    ↓
                              Update Manifest
                                    ↓
                              ArgoCD (CD)
                                    ↓
                              Kubernetes (k3d)
                                    ↓
                              Sock Shop (11 services)
                                    ↓
                        Prometheus + Grafana + Loki
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🚀 Getting Started

### Prerequisites

- Docker (v20+)
- k3d (v5+)
- kubectl (v1.28+)
- Helm (v3+)
- Git

### Installation

1. Clone the repository
   ```sh
   git clone https://github.com/dali4833/sre-masterpiece.git
   cd sre-masterpiece
   ```

2. Create Kubernetes Cluster
   ```sh
   k3d cluster create sre-masterpiece --agents 2
   ```

3. Deploy Sock Shop
   ```sh
   kubectl create namespace sock-shop
   kubectl apply -f local-dev/kubernetes/sock-shop/manifests -n sock-shop
   ```

4. Install ArgoCD
   ```sh
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.14.3/manifests/install.yaml
   ```

5. Install Monitoring
   ```sh
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 💻 Usage

### Access Services

| Service   | Command | URL |
|-----------|---------|-----|
| Sock Shop | `kubectl port-forward svc/front-end -n sock-shop 8079:80` | http://localhost:8079 |
| ArgoCD    | `kubectl port-forward svc/argocd-server -n argocd 8080:443` | https://localhost:8080 |
| Grafana   | `kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80` | http://localhost:3000 |

### CI/CD Workflow

1. Edit service code in `local-dev/sock-shop/src/[service]/`
2. Commit and push to GitHub
3. GitHub Actions builds Docker image
4. Image pushed to GHCR
5. Manifest updated automatically
6. ArgoCD auto-deploys to Kubernetes

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🌐 Roadmap

- [x] Local Kubernetes cluster (k3d)
- [x] Sock Shop deployment (11 microservices)
- [x] ArgoCD GitOps setup
- [x] CI/CD pipelines (7 services)
- [x] Monitoring stack (Prometheus + Grafana)
- [x] Log aggregation (Loki)
- [x] Alert rules
- [ ] Service Mesh (Istio)
- [ ] Security scanning (Trivy)
- [ ] Secrets management (Vault)
- [ ] Chaos Engineering (Chaos Mesh)
- [ ] AWS EKS deployment
- [ ] Azure AKS deployment
- [ ] GCP GKE deployment

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🤝 Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 📞 Contact

Dali - [@dali4833](https://github.com/dali4833)

Project Link: [https://github.com/dali4833/sre-masterpiece](https://github.com/dali4833/sre-masterpiece)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🙏 Acknowledgments

* [Sock Shop by Weaveworks](https://microservices-demo.github.io/)
* [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
* [Kubernetes Documentation](https://kubernetes.io/docs/)
* [Prometheus Documentation](https://prometheus.io/docs/)
* [Grafana Documentation](https://grafana.com/docs/)
* [Best-README-Template](https://github.com/othneildrew/Best-README-Template)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/dali4833/sre-masterpiece.svg?style=for-the-badge
[contributors-url]: https://github.com/dali4833/sre-masterpiece/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/dali4833/sre-masterpiece.svg?style=for-the-badge
[forks-url]: https://github.com/dali4833/sre-masterpiece/network/members
[stars-shield]: https://img.shields.io/github/stars/dali4833/sre-masterpiece.svg?style=for-the-badge
[stars-url]: https://github.com/dali4833/sre-masterpiece/stargazers
[issues-shield]: https://img.shields.io/github/issues/dali4833/sre-masterpiece.svg?style=for-the-badge
[issues-url]: https://github.com/dali4833/sre-masterpiece/issues
[license-shield]: https://img.shields.io/github/license/dali4833/sre-masterpiece.svg?style=for-the-badge
[license-url]: https://github.com/dali4833/sre-masterpiece/blob/main/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/dali4833
[Kubernetes]: https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white
[Kubernetes-url]: https://kubernetes.io/
[Docker]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[Docker-url]: https://www.docker.com/
[GitHub-Actions]: https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white
[GitHub-Actions-url]: https://github.com/features/actions
[ArgoCD]: https://img.shields.io/badge/ArgoCD-orange?style=for-the-badge&logo=argo&logoColor=white
[ArgoCD-url]: https://argo-cd.readthedocs.io/
[Git]: https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white
[Git-url]: https://git-scm.com/
[Prometheus]: https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white
[Prometheus-url]: https://prometheus.io/
[Grafana]: https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white
[Grafana-url]: https://grafana.com/
[Loki]: https://img.shields.io/badge/Loki-F46800?style=for-the-badge&logo=grafana&logoColor=white
[Loki-url]: https://grafana.com/oss/loki/
