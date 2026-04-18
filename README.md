# StackFlow 🚀

> **Enterprise-grade DevSecOps ecosystem** — from code to production with GitOps, observability, and zero-downtime deployments on AWS EKS.

![StackFlow Architecture](docs/images/architecture.png)

---

## 📌 Overview

StackFlow is a complete, end-to-end DevOps pipeline that demonstrates a **production-grade** cloud-native workflow. It covers the entire software lifecycle:

| Layer | Technologies |
|---|---|
| **Application** | React (Vite) + Node.js (Express) + PostgreSQL |
| **Containerization** | Docker multi-stage builds |
| **Infrastructure** | Terraform → AWS VPC, EKS, RDS, ALB, IAM |
| **Packaging** | Helm charts with environment-specific overrides |
| **CI/CD** | GitHub Actions + Jenkins (dual-path) |
| **GitOps** | Argo CD + Argo Rollouts |
| **Observability** | Prometheus, Grafana, ELK Stack, Jaeger, AlertManager |
| **Security** | Trivy, Snyk, OPA, Network Policies, Secrets Manager |

---

## 🏗 Architecture

### CI/CD Pipeline Flow

![CI/CD Pipeline](docs/images/cicd-pipeline.png)

```
Developer Push → GitHub Actions → Docker Build → Trivy Scan → ECR Push → Helm Update → Argo CD Sync
```

**Key Design Decisions:**
- 🔒 Security scan runs **before** push — vulnerable images never reach the registry
- 🔄 GitOps model — CI updates Helm values, Argo CD handles deployment
- 🌿 Branch-based environments — each branch maps to a namespace and strategy

### Deployment Strategies

| Branch | Environment | Strategy | Details |
|---|---|---|---|
| `devops` | `dev` namespace | Direct Deploy | Fast iteration, minimal replicas |
| `test` | `test` namespace | **Canary** | 20% → 50% → 100% with pause gates |
| `main` | `prod` namespace | **Blue-Green** | Zero-downtime, manual promotion |

### Observability Stack

![Observability](docs/images/observability.png)

| Pillar | Pipeline |
|---|---|
| **Metrics** | Backend `/metrics` → Prometheus → Grafana + AlertManager → Slack |
| **Logging** | Winston → Filebeat → Logstash → Elasticsearch → Kibana |
| **Tracing** | OpenTelemetry SDK → OTel Collector → Jaeger |

---

## 🛠 Getting Started

### Prerequisites

- Docker & Docker Compose
- AWS CLI (configured)
- Terraform >= 1.5
- kubectl
- Helm 3

### Local Development (Docker Compose)

```bash
# Clone the repo
git clone https://github.com/your-org/stackflow.git
cd stackflow

# Set up environment variables
cp .env.example docker/.env
# Edit docker/.env with your credentials

# Start all services
cd docker
docker-compose up -d
```

Visit `http://localhost` to view the frontend.

### Infrastructure Provisioning

```bash
cd terraform

# Initialize with remote state
terraform init

# Provide password securely (never hardcode!)
export TF_VAR_db_password="YourStrongPassword@123"

# Plan and apply
terraform plan
terraform apply
```

### EKS Cluster Bootstrap

```bash
# After terraform apply, bootstrap the cluster
./scripts/eks-bootstrap.sh
```

This installs:
- ✅ ALB Ingress Controller
- ✅ Argo CD
- ✅ Argo Rollouts

### Deploy with Argo CD

```bash
# Apply Argo CD application manifests
kubectl apply -f gitops/apps/dev.yaml
kubectl apply -f gitops/apps/test.yaml
kubectl apply -f gitops/apps/prod.yaml
```

---

## 📂 Project Structure

```
stackflow/
├── app/
│   ├── backend/          # Node.js Express API + observability
│   └── frontend/         # React SPA (Vite) + Nginx
├── database/             # SQL init and seed scripts
├── docker/               # Docker Compose for local dev
├── terraform/            # AWS infrastructure (VPC, EKS, RDS, ALB, IAM)
├── helm/stackflow/       # Helm chart with env-specific values
├── cicd/jenkins/         # Jenkinsfile + build scripts
├── .github/workflows/    # GitHub Actions CI/CD pipeline
├── gitops/               # Argo CD Application manifests
├── observability/
│   ├── alerting/         # AlertManager + Slack + Prometheus rules
│   ├── logging/          # ELK Stack (Elasticsearch, Logstash, Kibana)
│   ├── monitoring/       # Prometheus + Grafana configs
│   └── tracing/          # OpenTelemetry Collector + Jaeger
├── security/
│   ├── trivy/            # Container image scanning config
│   ├── snyk/             # Dependency vulnerability scanning
│   └── opa/              # Admission control policies
├── k8s/                  # Raw Kubernetes manifests
├── scripts/              # Setup, deploy, cleanup, rollback scripts
└── docs/                 # Architecture, security, troubleshooting docs
```

---

## 🔐 Security

| Layer | Implementation |
|---|---|
| **Image Scanning** | Trivy scans in CI before ECR push (blocks on HIGH/CRITICAL) |
| **Dependency Scanning** | Snyk integration for Node.js dependencies |
| **Admission Control** | OPA Gatekeeper — enforces `runAsNonRoot` on all pods |
| **Network Policies** | Only frontend → backend traffic allowed |
| **Secrets** | AWS Secrets Manager for DB credentials (no hardcoded passwords) |
| **IAM** | Least-privilege roles for EKS cluster and worker nodes |
| **TLS** | ACM certificate + ALB HTTPS listener with TLS 1.3 |
| **Encryption** | RDS storage encryption at rest enabled |

---

## 📊 Infrastructure Specs

| Resource | Specification |
|---|---|
| **VPC** | `10.0.0.0/16` — 3 private + 3 public subnets across 3 AZs |
| **EKS** | Kubernetes 1.29 — managed node group (1–4 `t3.small` nodes) |
| **RDS** | PostgreSQL 16.1 — encrypted, private subnet only |
| **ALB** | Internet-facing — HTTP→HTTPS redirect, TLS 1.3 |
| **State** | S3 backend + DynamoDB locking for Terraform |
| **Monitoring** | CloudWatch alarms → SNS → email/Slack notifications |

---

## 🚀 Deployment Strategy Details

### Canary (Test Environment)

```yaml
strategy:
  canary:
    steps:
      - setWeight: 20       # 20% traffic to new version
      - pause: { duration: 1h }
      - setWeight: 50       # 50% traffic
      - pause: { duration: 1h }
      # Auto-promote to 100%
```

### Blue-Green (Production)

```yaml
strategy:
  blueGreen:
    activeService: stackflow-frontend
    previewService: stackflow-frontend-preview
    autoPromotionEnabled: false   # Manual promotion required
```

---

## 🧹 Cleanup

```bash
# Remove all AWS resources
cd terraform
terraform destroy

# Or use the cleanup script
./scripts/cleanup.sh
```

---

Built with ❤️ by Pradeep | Enterprise DevOps Architecture
