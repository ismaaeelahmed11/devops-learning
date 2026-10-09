# ECS Project — Production-Grade Container Deployment

A Go web application deployed to AWS ECS Fargate, accessible over HTTPS via a custom domain. Built with Terraform, automated with GitHub Actions, and secured with ACM.

**Live URL:** https://tm.ismaaeelahmed.co.uk *(demo — infrastructure destroyed after submission to avoid AWS charges)*

---

## Architecture

![draw.io architecture diagram](screenshots/39b-architecture-drawio.png)

### Mermaid Version

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
- **IaC:** Terraform with 8 modules + S3 remote state with native locking
- **CI/CD:** GitHub Actions with OIDC authentication (no static keys)

---

## The Big Four

### What is this app?

A minimal Go web server exposing two endpoints:

- `/` — returns a welcome message
- `/health` — returns `{"status":"ok"}`

It's deliberately small. The point isn't the app — it's the **infrastructure and automation around it**. Containerised with a multi-stage Dockerfile (4.42MB scratch image), pushed to ECR, run on ECS Fargate, exposed via HTTPS through an Application Load Balancer on a custom domain.

### Why this application?

I chose a small Go app because:

- **Go compiles to a static binary** — perfect for a `scratch` container. No OS, no shell, no package manager. 4.42MB total.
- **Small surface area** — no frameworks, no dependencies. Just `net/http` and `encoding/json` from the standard library.
- **Fast startup** — Fargate tasks start in seconds, no cold-start issues.
- **Easy to test** — the `/health` endpoint is exactly what load balancers and monitoring need.

The app is intentionally simple. The complexity is in the infrastructure, which is the actual learning goal.

### Why ECS? Why not a VM, Vercel, or Netlify?

**Why not Vercel/Netlify:** They're great for static sites and serverless functions, but they don't teach me how to run containers in production. The goal of this project was to learn ECS, ALB, networking, and IaC — not to deploy a website.

**Why not a plain EC2 VM:** A VM works, but I'd be managing the OS, Docker runtime, scaling, and health checks myself. ECS Fargate handles all of that — I define the container, AWS runs it. No patching, no capacity planning.

**Why ECS specifically:**
- It's AWS-native container orchestration — a skill used in real DevOps roles
- Fargate is serverless — no EC2 instances to manage
- Integrates cleanly with ALB, ECR, IAM, CloudWatch
- It's the natural step up from Docker before Kubernetes

### How many users are expected?

This is a portfolio project, so no production users. But the architecture is designed for scale:

- **ALB** distributes traffic across tasks
- **ECS Service** can scale from 1 task to N based on CPU/memory
- **Multi-AZ subnets** mean the service survives an AZ failure
- **Fargate** scales without capacity planning

If real traffic hit it, I'd bump `desired_count` in Terraform or add an Auto Scaling policy. The infrastructure is ready — the current config just reflects that it's a demo.

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
docker run -p 8080:8080 ecs-project:v1
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

### 1. App Running Locally
Go app running on `localhost:8080` — both routes (`/` and `/health`) responding. Proves the app works before touching Docker or AWS.

![App running locally](screenshots/01-app-running-locally.png)

### 2. Docker Image Built
Multi-stage Docker build complete. Final image is **4.42MB** — scratch-based, no OS, no shell. Compare that to a typical Python image at 200MB+.

![Docker image built](screenshots/02-dockerbuildfinished-and-filesize.png)

### 3. Container Running Locally
The image runs as a container and serves both routes correctly. If it doesn't work here, it won't work in AWS.

![Container running](screenshots/03-container-running-2-curl%20tests.png)

### 4. ECS Cluster Created (ClickOps)
Manual setup — ECS Fargate cluster created via the AWS Console. Doing it by hand first taught me what Terraform would automate later.

![ECS cluster](screenshots/06-ecs-cluster-created.png)

### 5. Application Load Balancer Created (ClickOps)
ALB configured with HTTP listener on port 80. This is the public entry point for all traffic.

![ALB created](screenshots/09-alb-created.png)

### 6. HTTPS Working (ClickOps)
Site live at `tm.ismaaeelahmed.co.uk` with a padlock. ACM certificate attached, HTTP redirecting to HTTPS. This proved the ClickOps setup worked before I tore it down.

![HTTPS working](screenshots/15a-https-home-page.png)

### 7. Terraform Initialised
Backend connected to S3, AWS provider downloaded, all 8 modules loaded. State is now shared between my laptop and GitHub Actions.

![Terraform init](screenshots/17-terraform-init.png)

### 8. Terraform Plan — VPC
14 resources to create: VPC, subnets, Internet Gateway, route tables, NAT Gateway. The plan shows exactly what will happen before anything is built.

![VPC plan](screenshots/18-terraform-plan-vpc.png)

### 9. Terraform Apply — ECS
Full stack deployed via Terraform — VPC, ECR, IAM, security groups, ALB, ECS cluster, task definition, and service. All 40+ resources created in one command.

![ECS apply](screenshots/31-terraform-apply-ecs.png)

### 10. HTTPS Working (Terraform)
Same HTTPS URL as the ClickOps version — but now every resource is managed by Terraform. Rebuildable in minutes. Deletable in one command.

![Terraform HTTPS working](screenshots/33a-terraform-https-home.png)

### 11. App Pipeline Success
GitHub Actions pipeline ran on push. Built the Docker image, tagged it with the commit SHA, pushed to ECR. Green tick — everything worked first time.

![App pipeline success](screenshots/37-app-pipeline-success.png)

### 12. Both Pipelines Green
App Build & Push and Terraform Apply — both passing. Two independent pipelines triggered by different file paths.

![Both pipelines green](screenshots/37b-ci-cd-both-pipelines-green.png)

### 13. Terraform Apply Pipeline Detail
Full step-by-step view: Checkout → Configure AWS (via OIDC) → Setup Terraform → Init → Plan → Apply → Post-deploy health check. Every step visible and passing.

![Terraform apply pipeline](screenshots/38-ci-cd-terraform-apply-detail.png)

### 14. Terraform Plan Pipeline
Terraform Plan pipeline running on a pull request. Validates code, runs `terraform fmt`, `validate`, and `plan` without applying. Catches problems before merge.

![Terraform plan pipeline](screenshots/41-ci-cd-terraform-plan.png)

### 15. Terraform Destroy Trigger
The destroy pipeline is manual-only and requires typing "destroy" to confirm. Prevents accidental teardown — good practice for production.

![Terraform destroy trigger](screenshots/42-ci-cd-terraform-destroy-trigger.png)

### 16. Architecture — Mermaid
Auto-rendering diagram in the README. Easy to update, lives with the code.

![Mermaid diagram](screenshots/39a-architecture-mermaid.png)

### 17. Architecture — draw.io
The polished version. Shows VPC, subnets, ALB, ECS Fargate, ECR, ACM, IAM, and GitHub Actions flow. Used for the LinkedIn showcase.

![draw.io diagram](screenshots/39b-architecture-drawio.png)

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