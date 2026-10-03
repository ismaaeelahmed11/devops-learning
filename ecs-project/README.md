# ECS Project — Production-Grade Container Deployment

A Go web application deployed to AWS ECS Fargate, accessible over HTTPS via a custom domain. Built with Terraform, automated with GitHub Actions, and secured with ACM.

**Live URL:** https://tm.ismaaeelahmed.co.uk *(demo — infrastructure destroyed after submission to avoid AWS charges)*

---

## Architecture

```mermaid
graph TB
    User([User Browser])
    
    User -->|HTTPS| CF[Cloudflare DNS<br/>tm.ismaaeelahmed.co.uk]
    CF -->|CNAME| ALB
    
    subgraph AWS["AWS Cloud - eu-west-2"]
        subgraph VPC["VPC 10.0.0.0/16"]
            subgraph AZ1["Public Subnet - eu-west-2a<br/>10.0.0.0/24"]
                ALB[Application Load Balancer]
                ECS[ECS Task<br/>Go App :8080]
            end
            subgraph AZ2["Public Subnet - eu-west-2b<br/>10.0.1.0/24"]
                ALB2[Application Load Balancer]
            end
            TG[Target Group<br/>Port 8080<br/>Health: /health]
            ECR[(ECR Repository)]
            ACM[ACM Certificate<br/>tm.ismaaeelahmed.co.uk]
            CW[CloudWatch Logs]
            IAM[IAM Roles<br/>Execution + Task]
        end
    end
    
    subgraph GitHub["GitHub"]
        GHA[GitHub Actions]
        OIDC[OIDC Provider]
    end
    
    ALB --> TG
    ALB2 --> TG
    TG --> ECS
    ECR -.->|pulls image| ECS
    ACM -.->|SSL cert| ALB
    ECS -.->|logs| CW
    IAM -.->|permissions| ECS
    
    GHA -->|build + push| ECR
    GHA -->|terraform apply| AWS
    GHA -.->|assumes via| OIDC
    OIDC -.->|trusts| IAM
```

---

## Overview

- **App:** Go web server with `/health` returning `{"status":"ok"}`
- **Container:** Multi-stage Dockerfile producing a 4.42MB scratch-based image
- **Registry:** Amazon ECR with scan-on-push
- **Compute:** ECS Fargate (0.25 vCPU, 512MB)
- **Networking:** Custom VPC, 2 public subnets across 2 AZs, Internet Gateway
- **Load Balancing:** Application Load Balancer with HTTP → HTTPS redirect
- **SSL:** ACM certificate for `tm.ismaaeelahmed.co.uk`
- **DNS:** Cloudflare CNAME pointing to the ALB
- **IaC:** Terraform with 7 modules + S3 remote state with native locking
- **CI/CD:** GitHub Actions with OIDC authentication (no static keys)

---

## Project Structure

```
ecs-project/
├── app/
│   ├── main.go
│   └── go.mod
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── backend.tf
│   └── modules/
│       ├── vpc/
│       ├── ecr/
│       ├── security-groups/
│       ├── iam/
│       ├── acm/
│       ├── alb/
│       ├── ecs/
│       └── oidc/
├── screenshots/
├── Dockerfile
├── .dockerignore
├── .gitignore
└── README.md
```

---

## Local Setup

### Prerequisites
- Docker
- Go 1.23+
- Terraform 1.11+
- AWS CLI configured

### Run the app locally

```bash
cd app
go run main.go
```

Visit `http://localhost:8080/health` → `{"status":"ok"}`

### Build and run the container

```bash
docker build -t ecs-project:v1 .
docker run -p 8080:80 ecs-project:v1
```

Visit `http://localhost:8080/health`

---

## Terraform Deployment

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Outputs:
- `alb_dns_name` — the ALB endpoint
- `ecr_repository_url` — where images are pushed

---

## CI/CD Pipelines

| Pipeline | Trigger | What it does |
|----------|---------|-------------|
| ECS App Build & Push | Push to `main` changing `app/` or `Dockerfile` | Builds Docker image, tags with SHA, pushes to ECR |
| ECS Terraform Plan | Pull request changing `terraform/` | Runs `fmt`, `init`, `validate`, `plan` |
| ECS Terraform Apply | Push to `main` changing `terraform/` | Runs `init`, `apply`, health check |
| ECS Terraform Destroy | Manual trigger | Destroys all infrastructure |

All pipelines use **OIDC** — no static AWS keys.

---

## Screenshots

See `screenshots/` for the full journey:
- Local app running
- Docker image build
- ECR repository
- ClickOps manual setup
- Terraform modules and deployment
- CI/CD pipelines passing
- HTTPS live on custom domain

---

## What I Learnt

- ClickOps first, then IaC — understanding the pieces before automating
- Multi-stage Docker builds and scratch images
- Terraform modules for reusability
- Remote state with S3 native locking
- OIDC for secure CI/CD without static keys
- Debugging IAM permissions, port conflicts, and health checks

---

## Troubleshooting Journey

**Issue 1: Container exited with code 1**
Port 80 requires root. Fixed by running the Go app on 8080 and updating the target group, security group, and task definition.

**Issue 2: ECS task couldn't create CloudWatch log group**
The execution role lacked `logs:CreateLogGroup`. Added an inline policy.

**Issue 3: GitHub Actions didn't trigger**
Workflows were in `ecs-project/.github/workflows/`. GitHub only reads from the repo root.

**Issue 4: `use_lockfile` unsupported**
Terraform version in CI was 1.9.0. Bumped to 1.11.0.

---

*Built with Go, Docker, Terraform, and GitHub Actions.*