# 🚀 Kubernetes GitOps Platform: Terraform, ArgoCD & Canary Releases

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![ArgoCD](https://img.shields.io/badge/argocd-%23ef7b4d.svg?style=for-the-badge&logo=argo&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white)

This project demonstrates the implementation of a modern, resilient infrastructure platform using the **GitOps** paradigm to manage the full lifecycle of Kubernetes applications. The platform automates everything from cluster provisioning to progressive delivery using Canary Release strategies and advanced observability.

## 🏗️ Project Architecture

The solution is designed following the ArgoCD **App of Apps** pattern, ensuring scalability and separation of concerns:

1.  **Infrastructure (IaC):** Provisioning the cluster core and base tooling via **Terraform**.
2.  **Continuous Delivery (GitOps):** **ArgoCD** monitors this repository and automatically synchronizes the desired state to the cluster.
3.  **Progressive Delivery:** Integration of **Argo Rollouts** to replace standard Deployments, enabling safe and controlled updates.
4.  **Observability:** A full **Prometheus & Grafana** stack for real-time metrics collection and performance visualization.

## 🛠️ Tech Stack

- **Kubernetes (Minikube/Docker Desktop):** Container orchestration.
- **Terraform:** Infrastructure as Code provisioning.
- **ArgoCD:** Declarative GitOps synchronization tool.
- **Argo Rollouts:** Controller for advanced deployment strategies (Canary/Blue-Green).
- **Prometheus & Grafana:** Monitoring and metrics stack.
- **GitHub Actions:** CI pipeline for manifest validation.

## 🚀 Key Features

### 1. App of Apps Pattern (Root Application)

We centralized management into a "master" application that orchestrates the installation of all other components (Monitoring, Production Apps, Redis, etc.), simplifying infrastructure governance.

### 2. Canary Release with Argo Rollouts

Unlike standard deployments, our Nginx application utilizes a progressive strategy:

- **Step 1:** Routes only 20% of traffic to the new version.
- **Step 2:** Pauses the deployment for a set duration (60s) to analyze stability.
- **Step 3:** Gradually expands to 50% and finally 100% if health criteria are met.

### 3. Integrated Observability

Configuration of **ServiceMonitors** allows Prometheus to automatically discover new applications and begin collecting CPU, Memory, and Network metrics, visualized through dynamic Grafana dashboards.

## 📦 Getting Started

1. **Provision Infrastructure:**
   ```bash
   cd terraform
   terraform init
   terraform apply -auto-approve
   ```
