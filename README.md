# HRGF DevOps Project - Automated Kubernetes Deployment

## Overview

This project automates the deployment of a simple Nginx web application to AWS EKS using Infrastructure as Code (Terraform), containerization (Docker), and CI/CD (GitHub Actions). The solution includes Helm for Kubernetes deployment management and Trivy for container security scanning.

**Tech Stack:** AWS EKS, Terraform, Docker, Kubernetes, Helm, GitHub Actions, Trivy

---

## How to Run IaC Code

### Prerequisites
- AWS CLI configured with credentials
- Terraform installed
- kubectl installed

### Deploy Infrastructure

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

**Deployment time:** ~20 minutes

After deployment, configure kubectl:
```bash
aws eks update-kubeconfig --region us-east-1 --name hrgf-eks-cluster
kubectl get nodes
```

### Cleanup
```bash
helm uninstall hrgf-app
kubectl delete svc hrgf-app
cd terraform
terraform destroy
```

---

## CI/CD Pipeline Setup

The pipeline triggers automatically on push to `main` branch.

### Required GitHub Secrets

Navigate to **Settings → Secrets and variables → Actions** and add:

- `AWS_ACCESS_KEY_ID` - Your AWS access key
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret key  
- `AWS_REGION` - `us-east-1`
- `AWS_ACCOUNT_ID` - Run: `aws sts get-caller-identity --query Account --output text`
- `ECR_REPOSITORY` - `hrgf-app`
- `EKS_CLUSTER_NAME` - `hrgf-eks-cluster`

### Trigger Deployment

```bash
git add .
git commit -m "Deploy application"
git push origin main
```

Pipeline runs automatically and deploys the application (~5-8 minutes).

---

## Design Choices

**Infrastructure:**
- **Public subnets only** - Eliminates NAT Gateway cost (~$32/month savings) while maintaining functionality for this demo
- **2 t3.small nodes** - Smallest EKS-compatible instance type, balances cost and performance
- **LoadBalancer service** - Simpler than Ingress for demo purposes, auto-provisions AWS ELB

**Application:**
- **Nginx Alpine** - Minimal image size (~23MB), production-ready
- **Helm over raw manifests** - Enables easy upgrades and rollbacks
- **Resource limits** - Prevents resource contention, ensures cluster stability

**CI/CD:**
- **GitHub Actions** - Native integration, free for public repos
- **Trivy scanning** - Automated vulnerability detection before deployment
- **ECR registry** - Native AWS integration, faster image pulls from EKS

**Cost Optimization:**
- 15GB disk per node (reduced from 20GB default)
- ECR lifecycle policy (keeps only last 5 images)
- Minimal architecture for demo purposes
- **Estimated cost:** ~$28-30 for 7 days

---

## Live Application URL

After deployment completes, get the application URL:

```bash
kubectl get svc hrgf-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

**Application URL:** `http://<LOAD-BALANCER-DNS>`

*(Load Balancer DNS will be available 2-3 minutes after deployment)*

---

## Project Structure

```
├── app/                    # Web application (index.html)
├── docker/                 # Dockerfile and .dockerignore
├── terraform/              # Infrastructure as Code
│   ├── main.tf            # EKS cluster, VPC, ECR
│   ├── variables.tf       # Input variables
│   ├── outputs.tf         # Output values
│   └── providers.tf       # AWS provider
├── helm/hrgf-app/         # Helm chart for deployment
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
├── k8s/                   # Alternative K8s manifests
├── .github/workflows/     # CI/CD pipeline
└── README.md
```

---

## Quick Test Locally

```bash
docker build -f docker/Dockerfile -t hrgf-app:test .
docker run -d -p 8080:80 --name test hrgf-app:test
curl http://localhost:8080
docker stop test && docker rm test
```

---

**Author:** Karthikeya Tenali  
**Email:** tenalikarthikeya67@gmail.com  
**GitHub:** github.com/karthik-tenali