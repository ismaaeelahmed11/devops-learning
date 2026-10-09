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

### Phase 1 — Local Development

#### 1. App Running Locally
Go app running on `localhost:8080` — both routes (`/` and `/health`) responding. Proves the app works before touching Docker or AWS.

![App running locally](screenshots/01-app-running-locally.png)

#### 2. Docker Image Built
Multi-stage Docker build complete. Final image is **4.42MB** — scratch-based, no OS, no shell. Compare that to a typical Python image at 200MB+.

![Docker image built](screenshots/02-dockerbuildfinished-and-filesize.png)

#### 3. Container Running Locally
The image runs as a container and serves both routes correctly. If it doesn't work here, it won't work in AWS.

![Container running](screenshots/03-container-running-2-curl%20tests.png)

---

### Phase 2 — ClickOps (Manual AWS Setup)

#### 4. ECR Repository Created
Private ECR repository created via the AWS Console. Manual first, so I understood what Terraform would automate later.

![ECR repository](screenshots/04-ecr-repository-created.png)

#### 5. Image Pushed to ECR
Docker image tagged and pushed to the private ECR registry via CLI. Confirmed the image was uploaded.

![Image pushed CLI](screenshots/05a-image-pushed-cli.png)

![Image in ECR console](screenshots/05b-image-in-ecr-console.png)

#### 6. ECS Cluster Created
ECS Fargate cluster created via the AWS Console. This is where the container will run.

![ECS cluster](screenshots/06-ecs-cluster-created.png)

#### 7. Task Definition Created
Task definition revision 1 — 0.25 vCPU, 512MB memory, container port 8080, CloudWatch logs configured.

![Task definition](screenshots/07-task-definition-created.png)

#### 8. Target Group Created
Target group with IP target type, port 8080, health check path `/health`.

![Target group](screenshots/08-target-group-created.png)

#### 9. Application Load Balancer Created
Internet-facing ALB across 2 AZs. This is the public entry point for traffic.

![ALB created](screenshots/09-alb-created.png)

#### 10. ALB Serving the App
Hit the ALB DNS directly — "Welcome to the ECS Project!" and `{"status":"ok"}` at `/health`.

![ALB home page](screenshots/11a-alb-home-page.png)

![ALB health check](screenshots/11b-alb-health-check.png)

#### 11. ACM Certificate Issued
SSL certificate issued for `tm.ismaaeelahmed.co.uk` — validated via DNS in Cloudflare.

![ACM certificate](screenshots/12-acm-certificate-issued.png)

#### 12. ALB HTTPS Listener Configured
HTTP:80 redirects to HTTPS:443. HTTPS listener forwards to the target group with the ACM cert attached.

![ALB HTTPS listener](screenshots/13-alb-https-listener.png)

#### 13. Cloudflare DNS Record
CNAME record pointing `tm.ismaaeelahmed.co.uk` → ALB DNS name.

![Cloudflare DNS record](screenshots/14-cloudflare-dns-record.png)

#### 14. HTTPS Live (ClickOps)
Site live at `https://tm.ismaaeelahmed.co.uk` with a valid padlock. ClickOps setup proven working.

![HTTPS home](screenshots/15a-https-home-page.png)

![HTTPS health](screenshots/15b-https-health-check.png)

---

### Phase 3 — Infrastructure as Code (Terraform)

#### 15. S3 Remote State Bucket
Terraform state bucket with versioning, encryption, and public access blocked. Shared between my laptop and GitHub Actions.

![TF state bucket](screenshots/16-tfstate-bucket-created.png)

#### 16. Terraform Init
Backend connected to S3. AWS provider downloaded, VPC module loaded.

![Terraform init](screenshots/17-terraform-init.png)

#### 17. Terraform Plan — VPC
7 resources to create: VPC, Internet Gateway, 2 public subnets, public route table, and 2 route table associations. No NAT Gateway — ECS runs in a public subnet.

![VPC plan](screenshots/18-terraform-plan-vpc.png)

#### 18. Terraform Apply — VPC
All 7 resources created. VPC ID and subnet IDs printed as outputs, feeding into later modules.

![VPC apply](screenshots/19-terraform-apply-vpc.png)

#### 19. Terraform Plan — ECR
1 resource to create: the ECR repository with scan-on-push enabled.

![ECR plan](screenshots/20-terraform-plan-ecr.png)

#### 20. Terraform Apply — ECR
ECR repository created.

![ECR apply](screenshots/21-terraform-apply-ecr.png)

#### 21. Terraform Plan — Security Groups
2 resources to create: `alb-sg` (80/443 from anywhere) and `service-sg` (8080 from ALB only).

![SG plan](screenshots/22-terraform-plan-sg.png)

#### 22. Terraform Apply — Security Groups
Both security groups created.

![SG apply](screenshots/23-terraform-apply-sg.png)

#### 23. Terraform Plan — IAM
3 resources to create: execution role, task role, and the AWS-managed ECS policy attachment.

![IAM plan](screenshots/24-terraform-plan-iam.png)

#### 24. Terraform Apply — IAM
IAM roles and policies created. Also added an inline policy for `logs:CreateLogGroup` since the managed policy doesn't include it.

![IAM apply](screenshots/25-terraform-apply-iam.png)

#### 25. Terraform ACM Lookup
ACM certificate referenced via data source — no resources created, existing cert reused.

![ACM lookup](screenshots/26-terraform-acm-lookup.png)

#### 26. Terraform Apply — ACM Output
Certificate ARN exported — feeds into the ALB module.

![ACM apply](screenshots/27-terraform-apply-acm.png)

#### 27. Terraform Plan — ALB
4 resources to create: ALB, target group, HTTP listener (redirect), HTTPS listener (forward).

![ALB plan](screenshots/28-terraform-plan-alb.png)

#### 28. Terraform Apply — ALB
ALB + target group created. HTTPS listener added after fixing a target group conflict.

![ALB apply](screenshots/29-terraform-apply-alb.png)

#### 29. Terraform Plan — ECS
3 resources to create: ECS cluster, task definition, and service.

![ECS plan](screenshots/30-terraform-plan-ecs.png)

#### 30. Terraform Apply — ECS
ECS cluster, task definition, and service live. Task running and registered with the target group.

![ECS apply](screenshots/31-terraform-apply-ecs.png)

#### 31. Cloudflare DNS Updated
CNAME updated to point at the new Terraform-managed ALB DNS name.

![Cloudflare DNS updated](screenshots/32-cloudflare-dns-updated.png)

#### 32. HTTPS Live (Terraform)
Same URL as ClickOps — but now every resource is managed by Terraform. Rebuildable in minutes. Deletable in one command.

![Terraform HTTPS home](screenshots/33a-terraform-https-home.png)

![Terraform HTTPS health](screenshots/33b-terraform-https-health.png)

#### 33. Terraform Plan — OIDC
3 resources to create: GitHub OIDC provider, IAM role, and AdministratorAccess policy attachment.

![OIDC plan](screenshots/34-terraform-plan-oidc.png)

#### 34. Terraform Apply — OIDC
GitHub Actions role created. Trust policy accepts both classic and immutable OIDC subject formats.

![OIDC apply](screenshots/35-terraform-apply-oidc.png)

#### 35. GitHub Secret Added
`AWS_ROLE_ARN` stored as a repository secret — used by all CI/CD pipelines via OIDC.

![GitHub secret](screenshots/36-github-secret-added.png)

---

### Phase 4 — CI/CD Pipelines

#### 36. App Pipeline Success
GitHub Actions pipeline ran on push — built the Docker image, tagged with commit SHA, pushed to ECR.

![App pipeline success](screenshots/37-app-pipeline-success.png)

#### 37. Both Pipelines Green
App Build & Push and Terraform Apply — both passing, triggered by different file paths.

![Both pipelines green](screenshots/37b-ci-cd-both-pipelines-green.png)

#### 38. Terraform Apply Pipeline Detail
Full step view: Checkout → Configure AWS (OIDC) → Setup Terraform → Init → Plan → Apply → Post-deploy health check.

![Terraform apply pipeline](screenshots/38-ci-cd-terraform-apply-detail.png)

#### 39. App Build Runs History
App Build & Push workflow runs — 3 successful runs shown.

![App build runs](screenshots/38b-ci-cd-app-build-runs.png)

#### 40. Terraform Plan Pipeline
Plan pipeline on pull requests — runs `fmt`, `init`, `validate`, `plan` without applying.

![Terraform plan pipeline](screenshots/41-ci-cd-terraform-plan.png)

#### 41. Terraform Destroy Trigger
Manual-only destroy pipeline. Requires typing "destroy" to confirm — prevents accidental teardown.

![Terraform destroy trigger](screenshots/42-ci-cd-terraform-destroy-trigger.png)

---

### Phase 5 — Architecture

#### 42. Mermaid Diagram
Auto-rendering diagram in the README. Easy to update, lives with the code.

![Mermaid diagram](screenshots/39a-architecture-mermaid.png)

#### 43. draw.io Diagram
Polished version — VPC, subnets, ALB, ECS Fargate, ECR, ACM, IAM, and GitHub Actions flow.

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