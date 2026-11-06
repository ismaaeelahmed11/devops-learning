# AWS ECS Fargate — Production-Grade Infrastructure, Terraform & CI/CD

**AWS · ECS Fargate · Terraform · Docker · Go · GitHub Actions · IAM/OIDC · ALB · ACM/HTTPS · CloudWatch**

> **Completed AWS engineering deployment | `eu-west-2` (London)**  
> Designed, deployed and verified a containerised Go service on AWS ECS Fargate, first through manual AWS configuration and then using modular Terraform and GitHub Actions. **The AWS infrastructure has since been removed to manage cost.** The original hostname, `tm.ismaaeelahmed.co.uk`, is preserved as historical deployment evidence, not a live demo.

**Project navigation:** [2:11 walkthrough](https://youtu.be/qpIZlJkWmos) · [Architecture](#architecture-diagram) · [Deployment evidence](#four-screenshots-that-prove-the-main-outcomes) · [Terraform](#aws-infrastructure--eight-terraform-modules) · [GitHub Actions](#cicd--github-actions-oidc--release-boundaries) · [Root-cause analysis](#troubleshooting--root-cause-analysis) · [42 evidence stages](#implementation-evidence--42-numbered-stages)

## Project Overview

I **engineered and deployed an end-to-end Go HTTP application on Amazon ECS Fargate**, bringing together containerisation, Infrastructure as Code, AWS networking, HTTPS, IAM, CI/CD, health checks and application logging.

I first configured the AWS resources manually to understand the full request and deployment paths. I then reproduced the environment through **eight Terraform modules**, established an **S3-backed remote state**, and implemented **four GitHub Actions workflows** for image publishing and Terraform operations. Following successful deployment demonstrations, I strengthened the repository's AWS authentication model, introducing **branch-restricted OIDC trust and repository-scoped ECR permissions** and making Terraform Apply manual-only.

The evidence includes **source code, a draw.io architecture diagram, working HTTPS screenshots, Terraform plan/apply outputs, GitHub Actions run history, a 2:11 technical walkthrough and 42 implementation stages**. The README also records real failures and how I diagnosed them.

### Verified Engineering Outcomes

| Area | Demonstrated result |
| --- | --- |
| **Application** | Go HTTP server with `GET /` and `GET /health` |
| **Container** | Multi-stage Go build; non-root `scratch` runtime; measured image size **4.42 MB** |
| **Compute** | ECS Fargate task configured at **0.25 vCPU / 512 MiB**, desired service count **1** |
| **Networking** | Custom VPC, two public subnets across two AZs, internet-facing ALB, IP target group, scoped inbound ECS security group |
| **TLS and DNS** | HTTP-to-HTTPS redirect, ACM-backed HTTPS listener, Cloudflare CNAME and working custom domain |
| **Infrastructure as Code** | **Eight Terraform modules**; S3 remote state with native lockfile support |
| **CI/CD** | **Four GitHub Actions workflows**; historical successful image-publishing and infrastructure runs; recorded **34-second image build/push** |
| **AWS identity** | GitHub OIDC federation; subsequently restricted to the `main` branch with an ECR-specific publishing policy |
| **Operations** | ALB `/health` checks, CloudWatch Logs and incident-level troubleshooting |
| **Cost control** | Deliberate lab teardown with retained source code, diagrams and run evidence |

This project demonstrates **production-grade engineering practices**, not a claim of operating a commercial production service. Its architecture decisions, deployment boundaries and known limitations are documented below.

---

## See It Working — Demo, Architecture & Evidence

### Technical walkthrough (2:11)

[![Watch the AWS ECS Fargate technical walkthrough](https://img.youtube.com/vi/qpIZlJkWmos/hqdefault.jpg)](https://youtu.be/qpIZlJkWmos)

**[▶ Watch the project walkthrough on YouTube](https://youtu.be/qpIZlJkWmos)** — Go/Docker build, ECS architecture, Terraform provisioning, workflows and troubleshooting.

### Architecture diagram

![AWS ECS Fargate architecture showing Cloudflare, ALB, ACM, ECS, ECR and GitHub Actions](screenshots/39b-architecture-drawio.png)

**Application request path**

```text
Browser → Cloudflare DNS → Public Application Load Balancer
                                     │
                      HTTP :80 redirects to HTTPS :443
                                     │
                     ALB terminates TLS using ACM certificate
                                     │
                         ALB IP target group :8080
                                     │
                           ECS Fargate task :8080
                                     │
                            Go HTTP application
                              GET / and /health
```

The ACM certificate is attached to the ALB HTTPS listener; it is **not a separate network hop**.

The public ALB terminates TLS, forwards to a target group with **IP targets** and checks `/health`. The demonstrated Fargate task used a **public subnet** but accepted inbound application traffic **only from the ALB security group** on port `8080`. The two public subnets supported ALB placement across two AZs; **one running task is not a multi-AZ high-availability application**.

**Infrastructure and delivery**

- **Terraform** manages AWS VPC resources, ECS, ECR, ALB, security groups, IAM and OIDC configuration.
- **GitHub Actions** builds and pushes a container image and separately manages Terraform planning, applying and teardown.
- **Amazon ECR** stores the image used by the Fargate task definition.
- **AWS OIDC federation** provides short-lived credentials to GitHub Actions.
- **CloudWatch Logs** receives application logs from the task.

### Four screenshots that prove the main outcomes

| **Working application over HTTPS** | **Historical GitHub Actions runs passed** |
| --- | --- |
| ![Go application served over HTTPS by Terraform-managed ECS](screenshots/33a-terraform-https-home.png) | ![Successful ECS image publishing and infrastructure workflows](screenshots/37b-ci-cd-both-pipelines-green.png) |
| Verified custom domain and TLS following the Terraform rebuild | Previously successful image-publishing and infrastructure-apply jobs |

| **Terraform applied ECS infrastructure** | **Minimal Docker image built** |
| --- | --- |
| ![Terraform apply creating ECS Fargate resources](screenshots/31-terraform-apply-ecs.png) | ![Docker multi-stage build and 4.42MB image](screenshots/02-dockerbuildfinished-and-filesize.png) |
| ECS cluster/service/task definition created through IaC | Multi-stage build produced a measured 4.42 MB image |

**Evidence interpretation:** A green **App Build & Push** run proves a successful image build and ECR publication; it **does not, by itself, prove automatic ECS service deployment**. The working HTTPS service and Terraform apply are evidenced independently. See [CI/CD design and limitations](#cicd--github-actions-oidc--release-boundaries).

---

## Engineering Capabilities — Source Code & Evidence

| Engineering discipline | Work demonstrated | Evidence |
| --- | --- | --- |
| **AWS / Cloud engineering** | ECS Fargate, ECR, ALB, ACM, IAM, VPC and CloudWatch | [Terraform modules](terraform/modules/), [AWS deployment evidence](#implementation-evidence--42-numbered-stages) |
| **Terraform / Infrastructure as Code** | Eight modular components, variables, outputs, S3 state and locking | [Terraform source](terraform/), [ECS apply](screenshots/31-terraform-apply-ecs.png) |
| **Docker / containers** | Built a Go binary in a multi-stage image, ran it non-root, tested locally | [Dockerfile](Dockerfile), [Go app](app/main.go), [image-size evidence](screenshots/02-dockerbuildfinished-and-filesize.png) |
| **CI/CD / GitHub Actions** | Image publishing, PR formatting/validation, manual Terraform plan/apply and confirmed destroy | [Repository workflows](../.github/workflows/), [passing workflows](screenshots/37b-ci-cd-both-pipelines-green.png) |
| **Networking** | ALB listeners, target groups, ports, health checks, security groups, DNS | [ALB/Terraform code](terraform/modules/alb/), [HTTPS evidence](screenshots/33a-terraform-https-home.png) |
| **Identity & security** | ECS execution permissions, ACM TLS, GitHub OIDC, SG-restricted application ingress | [IAM module](terraform/modules/iam/), [OIDC module](terraform/modules/oidc/) |
| **Monitoring & operations** | ALB `/health` checks and CloudWatch Logs; diagnosed missing log permissions | [Application endpoint](app/main.go), [IAM incident](#troubleshooting--root-cause-analysis) |
| **Troubleshooting** | Resolved port-binding, logging IAM, Terraform version and workflow discovery problems | [Incident investigations](#troubleshooting--root-cause-analysis) |
| **Cost awareness** | Designed a budget-conscious lab with controlled teardown | [Destroy workflow](../.github/workflows/ecs-terraform-destroy.yml), [teardown evidence](screenshots/42-ci-cd-terraform-destroy-trigger.png) |

---

## Architecture Decisions & Engineering Trade-offs

### Why write a Go application?

I wrote a small Go HTTP service with two endpoints:

| Endpoint | Responsibility |
| --- | --- |
| `GET /` | Return an application welcome response |
| `GET /health` | Return `{"status":"ok"}` for service/target health checks |

The app is intentionally small: the challenge was the **delivery platform around it**, not a complex business application. Go compiles into a standalone executable, making it suitable for a minimal runtime container.

### Why a multi-stage Dockerfile and `scratch` image?

The build stage compiles the Go binary, while the final `scratch` stage contains the executable without a full Linux userland. The final image measured **4.42 MB**. It also runs as a **non-root user**.

These choices demonstrate familiarity with **multi-stage builds, runtime dependencies, image efficiency and container security**. A `scratch` image removes shells and package managers from the runtime, but it does not remove the need for vulnerability management or application security testing.

### Why ECS Fargate?

Fargate runs the container without requiring me to provision and administer EC2 container hosts. I still configured the **task definition, CPU/memory, image, networking, IAM, security groups, logging and ALB integration**. That is the DevOps/platform work this project was designed to demonstrate.

### Why build it manually *and then* use Terraform?

I deliberately used the AWS Console/CLI first to understand resource dependencies—ECR → ECS task → target group → ALB listeners → ACM → DNS—rather than copying a Terraform configuration without understanding the services.

After demonstrating the application over HTTPS, I recreated the resources in **eight separate Terraform modules**. This turned working infrastructure into documented, version-controlled configuration and gave me experience troubleshooting **Terraform ownership, existing AWS resources and deployment order**.

### Why public subnets for the Fargate task?

This was a **cost-conscious lab architecture**. The Fargate task ran in a public subnet rather than adding NAT infrastructure. Inbound container traffic remained restricted to the ALB security group. For a more security-focused system, I would run ECS tasks in **private subnets**, using appropriately configured NAT/VPC endpoints and tightly scoped network policies.

### What scaling and availability did this prove?

The ALB spanned **two Availability Zones**, but the demonstrated service ran **one task**. This is a functioning deployment with health checking, **not proof of application-level high availability**. ECS service scaling, multi-task availability, auto scaling, failover testing and rollback would be separate exercises.

---

## AWS Infrastructure — Eight Terraform Modules

The project uses this structure:

```text
devops-learning/
├── .github/workflows/          # GitHub Actions files live at repository root
└── ecs-project/
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

| Terraform module | Engineering responsibility |
| --- | --- |
| **VPC** | VPC, Internet Gateway, two public subnets, routing |
| **ECR** | Private container registry and scan-on-push configuration |
| **Security groups** | Public HTTP/HTTPS to ALB; ECS app port accessible from ALB SG |
| **IAM** | Task execution role and required container execution/logging permissions |
| **ACM** | Lookup of an existing ACM certificate used for ALB TLS |
| **ALB** | Internet-facing ALB, IP target group, `/health`, redirect and TLS listeners |
| **ECS** | Cluster, Fargate task definition, service, ECR image, CloudWatch log setup |
| **OIDC** | GitHub federated identity provider and role used by Actions |

### ECS task and network configuration

| Setting | Implemented value |
| --- | --- |
| AWS region | `eu-west-2` |
| Compute | ECS Fargate |
| Task sizing | **0.25 vCPU / 512 MB RAM** |
| Container application port | **8080** |
| Target group | **`ip`** target type, port **8080**, `/health` path |
| ALB HTTP listener | **80 → 443 redirect** |
| ALB HTTPS listener | **443**, TLS via existing ACM certificate |
| DNS | Cloudflare record for `tm.ismaaeelahmed.co.uk` |
| Network | Custom VPC; two public subnets in separate AZs |
| Runtime logs | CloudWatch Logs |
| Registry | Amazon ECR with scan-on-push configured |

### Remote Terraform state

Terraform state was stored in **Amazon S3**, with versioning, encryption, public access blocking and native Terraform S3 lockfile support. Remote state allows CLI and CI operations to reference the same infrastructure state; **locking helps prevent simultaneous writers from corrupting the state**.

I encountered a real compatibility issue here: the `use_lockfile` backend option was unsupported by the **Terraform 1.9.0** version initially used in CI. I updated CI to **Terraform 1.11.0** so the workflow and backend configuration were compatible.

> **Bootstrap dependency:** The S3 backend and the ACM certificate have to exist before the relevant Terraform operations can succeed. ECS task creation also depends on having a suitable container image in ECR. Reproducing this environment requires working through those dependencies rather than assuming a single fresh `terraform apply` handles every prerequisite.

### Terraform commands

From `devops-learning/ecs-project/`:

```bash
cd terraform
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

Always review the plan, AWS charges, existing resources and account-specific values before applying. Historical screenshots record successful provisioning; they do not guarantee the same plan against different AWS accounts or provider versions.

**Terraform evidence:** [S3 state bucket](screenshots/16-tfstate-bucket-created.png) · [Terraform init](screenshots/17-terraform-init.png) · [VPC plan](screenshots/18-terraform-plan-vpc.png) · [IAM apply](screenshots/25-terraform-apply-iam.png) · [ALB apply](screenshots/29-terraform-apply-alb.png) · [ECS apply](screenshots/31-terraform-apply-ecs.png)

---

## CI/CD — GitHub Actions, OIDC & Release Boundaries

The four workflows are stored at the **repository root**, in [`devops-learning/.github/workflows/`](../.github/workflows/). This is important: GitHub Actions does not discover workflow files located solely under `ecs-project/.github/workflows/`.

The project contains **historical successful deployment runs** and a **subsequently security-hardened workflow configuration**. The table below reflects the current source code, rather than assuming every historical workflow still has the same trigger or permissions.

| Workflow | Current trigger | Current implementation |
| --- | --- | --- |
| [**ECS App Build & Push**](../.github/workflows/ecs-app-build-push.yml) | Push to `main` for the app/Dockerfile/workflow, or manual dispatch | Authenticate to AWS using OIDC; build and push `github.sha` and `latest` image tags to ECR |
| [**ECS Terraform Plan**](../.github/workflows/ecs-terraform-plan.yml) | Terraform-related pull requests, or manual dispatch | **PR:** `fmt -check -recursive`, `init -backend=false`, `validate` without AWS credentials. **Manual main-branch job:** AWS-authenticated `terraform plan` using `AWS_PLAN_ROLE_ARN` |
| [**ECS Terraform Apply**](../.github/workflows/ecs-terraform-apply.yml) | **Manual dispatch only** | Assume `AWS_ROLE_ARN`, initialise Terraform, run apply, then poll the HTTPS `/health` endpoint |
| [**ECS Terraform Destroy**](../.github/workflows/ecs-terraform-destroy.yml) | **Manual dispatch** with `confirm=destroy` | Assume `AWS_ROLE_ARN`, initialise state and run Terraform destroy |

### Application image publication

```text
Git push to main / manual dispatch
                 │
                 ▼
          GitHub Actions
                 │
                 ▼
   Short-lived AWS credentials (OIDC)
                 │
                 ▼
        Docker build and tag
                 │
                 ▼
     Amazon ECR: SHA + latest
```

The application workflow produces a version-traceable image using **`github.sha`** and also pushes `latest`. A previously successful run completed image building and publication in **34 seconds**.

**Release boundary:** The image-publishing workflow **does not update an ECS task definition or roll out a new ECS service revision**. The Terraform ECS task definition currently references the static image tag `:v2`, not the newly published SHA. A complete continuous-deployment path would select the published image digest/tag, register a new task-definition revision, update the service, await stability and verify the application.

### Terraform validation, deployment and permissions

The Terraform validation job now runs on pull requests **without AWS credentials**, reducing the privileges needed for routine code checks. AWS-authenticated planning is **manual-only**, runs on `main`, and uses a distinct `AWS_PLAN_ROLE_ARN` secret.

Terraform Apply is also **manual-only** rather than running automatically on every change. Terraform Destroy requires the operator to enter the exact confirmation value `destroy`.

The current [OIDC Terraform module](terraform/modules/oidc/main.tf) has been hardened in three specific ways:

1. Removed the original AWS-managed `AdministratorAccess` attachment.
2. Restricted OIDC audience and subject to `sts.amazonaws.com` and `repo:ismaaeelahmed11/devops-learning:ref:refs/heads/main`.
3. Added an inline ECR publishing policy: `ecr:GetAuthorizationToken` and repository-scoped image-upload actions for `ecs-project`.

**Redeployment dependency:** The currently defined GitHub Actions IAM role is **ECR-publish-only**. It does not grant Terraform provisioning or destruction permissions. `AWS_PLAN_ROLE_ARN` requires a separately configured planning role, and Apply/Destroy require appropriately scoped infrastructure permissions before they can successfully run again. The original AWS environment and historical roles have been removed. The published code demonstrates the security changes, not a fresh end-to-end AWS deployment after those changes.

The manually dispatched Apply/Destroy workflows still contain `-auto-approve`; manual dispatch or a typed confirmation is **not the same as an independent reviewer approval gate**. A future long-running deployment would use separate environment roles, reviewed plan artifacts and protected environment approvals.

**Historical CI/CD evidence:** [Successful app pipeline](screenshots/37-app-pipeline-success.png) · [Build and infrastructure workflows](screenshots/37b-ci-cd-both-pipelines-green.png) · [Apply run steps](screenshots/38-ci-cd-terraform-apply-detail.png) · [Earlier plan run](screenshots/41-ci-cd-terraform-plan.png) · [Destroy dispatch](screenshots/42-ci-cd-terraform-destroy-trigger.png)

---

## Application Health, Logs & Operations

### Health checking at multiple layers

The Go app serves `GET /health` with:

```json
{"status":"ok"}
```

The **ALB target group** checks `/health` on the Fargate task. The HTTPS endpoint was also tested after both the manual deployment and the Terraform rebuild. These checks validate connectivity and an application response; they are **not a comprehensive readiness, dependency or performance test**.

**Proof:** [Application health through ALB](screenshots/11b-alb-health-check.png) · [HTTPS `/health` after Terraform](screenshots/33b-terraform-https-health.png)

### CloudWatch logging and permissions

The task was configured to deliver container logs to **Amazon CloudWatch Logs**. Initially, task startup/logging failed because the execution role lacked `logs:CreateLogGroup`. I investigated the IAM permissions and added the necessary permission to resolve the issue.

That failure demonstrated an important AWS distinction: **container execution permissions and application networking must both be correct for a service to start and become healthy**. Configuring a log driver is not enough if its role lacks the required permissions.

---

## Troubleshooting & Root Cause Analysis

This project was built and validated through real incidents affecting container startup, IAM, infrastructure ownership and CI/CD. Each fix required tracing a failure across service boundaries rather than simply rerunning a command.

| Incident | Investigation | Resolution / engineering insight |
| --- | --- | --- |
| **Container exited with code 1** | Reviewed the non-root container runtime and privileged-port binding | Changed Go listener to **8080** and aligned task definition, ALB target group and security groups |
| **CloudWatch Logs permission failure** | Inspected task execution permissions and log-driver configuration | Added required `logs:CreateLogGroup` permission; container startup depends on IAM as well as runtime configuration |
| **GitHub Actions workflows not discovered** | Verified GitHub's required workflow directory | Moved YAML files into repository-root `.github/workflows/` |
| **Terraform S3 locking failed in CI** | Compared the `use_lockfile` backend setting against the workflow's Terraform version | Updated CI from Terraform **1.9.0 to 1.11.0** |
| **ALB/target group resource conflict** | Investigated resources remaining from manual provisioning and Terraform dependencies | Resolved conflicting resources and completed ALB/HTTPS provisioning |
| **Overly broad CI/CD AWS permissions** | Reviewed the OIDC role's trust policy and managed IAM attachments | Removed `AdministratorAccess`, narrowed trust to `main`, and added repository-scoped ECR publishing rights |

### Operational Lessons

- **A successful Docker build is not a successful ECS deployment.** Container startup, runtime ports, IAM, target registration and health checks all need to succeed.
- **A working HTTPS endpoint reflects a complete request path.** DNS, ACM, listeners, security groups, target health and the Go service must agree.
- **Terraform correctness includes state and ownership.** Backend compatibility, externally created prerequisites and conflicts with manually provisioned resources are operational concerns.
- **CI success has a precise scope.** ECR image publication, Terraform infrastructure deployment and ECS service release are separate events.
- **OIDC is an authentication mechanism, not an IAM permission policy.** The assumed role still requires appropriate scoping and review.

---

## Running the Project Locally & Recreating AWS

**Prerequisites:** Go toolchain compatible with `app/go.mod`, Docker and a terminal.

```bash
git clone https://github.com/ismaaeelahmed11/devops-learning.git
cd devops-learning/ecs-project

# Run Go server locally
cd app
go run main.go
```

In a second terminal:

```bash
curl http://localhost:8080/
curl http://localhost:8080/health
# Expected /health response: {"status":"ok"}
```

Build and test the container from `ecs-project/`:

```bash
cd ../  # Return from app/ to ecs-project/ before building

docker build -t ecs-project:v1 .
docker images ecs-project
docker run --rm -p 8080:8080 ecs-project:v1
```

Test the two endpoints again with `curl` in a separate terminal. The screenshot records an approximately **4.42 MB** final image from the original project build; exact image size may vary if source files or toolchains change.

### Recreating the AWS deployment

The historical AWS environment **no longer exists**. A re-deployment requires an AWS account and CLI, correct IAM permissions, an accessible **S3 state backend**, a valid **ACM certificate in `eu-west-2`**, a Cloudflare-managed domain, the container image in ECR and compatible Terraform dependencies.

A safe sequence is:

1. **Inspect and adapt** the Terraform variables, backend, ARNs and Cloudflare/ACM dependencies for your own account; check costs first.
2. **Bootstrap or verify** the state bucket and ACM certificate.
3. **Provision the registry and prerequisites**, push the container image to ECR, then complete ECS task/service provisioning—respecting the Terraform module dependencies and image reference.
4. **Review and apply** the Terraform plan.
5. **Verify** ECS task/service health, ALB target health, HTTPS and CloudWatch logs.
6. **Teardown deliberately** with the reviewed `terraform destroy` process or the manual workflow; check for separately managed resources afterward.

> This is an implementation reference, not a guarantee of one-command deployment in a fresh AWS account. The state backend, ACM certificate, DNS, registry image and GitHub OIDC role may need independent setup.

---

## Security, Reliability & Engineering Roadmap

The completed deployment proves infrastructure and application delivery. The repository also shows subsequent security improvements and identifies controls that would matter in a continuously operated production environment.

| Area | Implemented / evidenced | Next improvement for a long-running environment |
| --- | --- | --- |
| **Container runtime** | Non-root `scratch` image; 4.42 MB measured size | Dependency updates, image signing/SBOM and vulnerability policy gates |
| **ECR** | Private repository; scan-on-push; SHA-tagged image publishing | Immutable tags, deployments by image digest, release promotion |
| **AWS authentication** | OIDC credentials; main-branch trust; ECR-scoped image-publishing permissions defined in Terraform | Distinct least-privilege roles for plan, apply and destroy; environment approvals |
| **Network access** | Public HTTPS ALB; ECS ingress restricted to ALB SG on port 8080 | Move tasks to private subnets with planned NAT/VPC endpoints |
| **Availability** | ALB spans two AZs; ECS desired count of one task | Two or more tasks across AZs, autoscaling and tested failover |
| **Release automation** | Image build/push and Terraform workflows | Bind published image to a new ECS task revision, verify stability and rollback |
| **Observability** | CloudWatch Logs; `/health` endpoint and ALB target health checks | Alerts, latency/error metrics, dashboards, trace correlation and runbooks |
| **Testing** | Local Go/Docker HTTP checks; ALB HTTPS validation; Terraform formatting/validation | Automated Go tests, integration/smoke tests, security gates and chaos/failure testing |
| **Infrastructure review** | Pull-request Terraform formatting and validation without AWS credentials | Reviewed plan artifact, policy checks and protected deployment environments |

These roadmap items are **not claimed as completed functionality**. They document how I would evolve this demonstrated architecture toward a continuously operated production service.

---

## Cost Management

ECS Fargate tasks, ALBs, container storage and other AWS services can incur charges even with little traffic. I kept this project time-limited, provided infrastructure teardown through GitHub Actions and removed the AWS resources after completing the demonstration. The documentation and code remain available without leaving a paid workload running.

**Teardown note:** `terraform destroy` targets only resources in the relevant state. Verify any pre-existing ACM certificate, state bucket, ECR images, DNS records or other separately managed resources and ongoing charges independently. Never run a destructive workflow against an environment you intend to retain.

---

## Implementation Evidence — 42 Numbered Stages

The **42 evidence entries** are grouped into five project phases. The four featured screenshots appear at the top of this README for quick review; their original entries link to those files rather than displaying them twice. The evidence combines local tests, AWS resources, Terraform results, successful workflows, HTTPS output and the final draw.io architecture diagram.

<details>
<summary><strong>Phase 1 — Local Development (3 evidence entries)</strong></summary>

### 1. Application Running Locally

The Go web server running on `localhost:8080`, with both `/` and `/health` responding.

![App Running Locally](screenshots/01-app-running-locally.png)

### 2. Docker Image Built

Successful multi-stage Docker build producing the 4.42 MB scratch-based image.

[View screenshot (featured above)](screenshots/02-dockerbuildfinished-and-filesize.png)

### 3. Container Running Locally

The application running successfully inside Docker, verified using curl requests.

![Container Running](screenshots/03-container-running-2-curl%20tests.png)

</details>

<details>
<summary><strong>Phase 2 — Manual AWS Deployment (11 evidence entries)</strong></summary>

### 4. ECR Repository Created

Private ECR repository created through the AWS Console.

![ECR Repository](screenshots/04-ecr-repository-created.png)

### 5. Image Pushed to ECR

The Docker image tagged and uploaded to Amazon ECR.

![Image Pushed CLI](screenshots/05a-image-pushed-cli.png)

![Image in ECR Console](screenshots/05b-image-in-ecr-console.png)

### 6. ECS Cluster Created

ECS Fargate cluster created manually.

![ECS Cluster](screenshots/06-ecs-cluster-created.png)

### 7. Task Definition Created

Task definition with 0.25 vCPU, 512 MB memory, port `8080` and CloudWatch logging.

![Task Definition](screenshots/07-task-definition-created.png)

### 8. Target Group Created

Target group using IP targets, port `8080` and the `/health` health check.

![Target Group](screenshots/08-target-group-created.png)

### 9. Application Load Balancer Created

Internet-facing ALB configured across two Availability Zones.

![Application Load Balancer](screenshots/09-alb-created.png)

### 10. ALB Serving the Application

The application and health endpoint responding through the ALB DNS hostname.

![ALB Home](screenshots/11a-alb-home-page.png)

![ALB Health Check](screenshots/11b-alb-health-check.png)

### 11. ACM Certificate Issued

ACM certificate successfully issued for the application domain.

![ACM Certificate](screenshots/12-acm-certificate-issued.png)

### 12. ALB HTTPS Listener Configured

HTTP redirect to HTTPS and HTTPS forwarding to the target group.

![ALB HTTPS Listener](screenshots/13-alb-https-listener.png)

### 13. Cloudflare DNS Record

Cloudflare CNAME pointing to the ALB hostname.

![Cloudflare DNS](screenshots/14-cloudflare-dns-record.png)

### 14. HTTPS Live — Manual Deployment

The application accessible through the custom domain with a valid HTTPS certificate.

![HTTPS Home](screenshots/15a-https-home-page.png)

![HTTPS Health Check](screenshots/15b-https-health-check.png)

</details>

<details>
<summary><strong>Phase 3 — Terraform Infrastructure (21 evidence entries)</strong></summary>

### 15. S3 Remote State Bucket

Terraform state bucket configured with versioning, encryption and public access blocked.

![Terraform State Bucket](screenshots/16-tfstate-bucket-created.png)

### 16. Terraform Initialisation

Terraform initialised successfully against the S3 backend.

![Terraform Init](screenshots/17-terraform-init.png)

### 17. VPC Terraform Plan

Seven networking resources planned, including VPC, Internet Gateway, public subnets and routing.

![Terraform VPC Plan](screenshots/18-terraform-plan-vpc.png)

### 18. VPC Terraform Apply

The VPC resources successfully provisioned.

![Terraform VPC Apply](screenshots/19-terraform-apply-vpc.png)

### 19. ECR Terraform Plan

Terraform plan for the ECR repository.

![Terraform ECR Plan](screenshots/20-terraform-plan-ecr.png)

### 20. ECR Terraform Apply

ECR repository created through Terraform.

![Terraform ECR Apply](screenshots/21-terraform-apply-ecr.png)

### 21. Security Group Terraform Plan

Security groups planned for the ALB and ECS service.

![Terraform Security Group Plan](screenshots/22-terraform-plan-sg.png)

### 22. Security Group Terraform Apply

ALB and ECS service security groups successfully created.

![Terraform Security Group Apply](screenshots/23-terraform-apply-sg.png)

### 23. IAM Terraform Plan

ECS task execution role, task role and IAM permissions planned.

![Terraform IAM Plan](screenshots/24-terraform-plan-iam.png)

### 24. IAM Terraform Apply

IAM resources created and required CloudWatch Logs permissions added.

![Terraform IAM Apply](screenshots/25-terraform-apply-iam.png)

### 25. ACM Certificate Lookup

Terraform data source used to reference the existing ACM certificate.

![Terraform ACM Lookup](screenshots/26-terraform-acm-lookup.png)

### 26. ACM Certificate Output

The certificate ARN made available to the ALB configuration.

![Terraform ACM Output](screenshots/27-terraform-apply-acm.png)

### 27. ALB Terraform Plan

Terraform plan covering ALB, target group and HTTP/HTTPS listeners.

![Terraform ALB Plan](screenshots/28-terraform-plan-alb.png)

### 28. ALB Terraform Apply

Application Load Balancer and target group provisioned after resolving the resource conflict.

![Terraform ALB Apply](screenshots/29-terraform-apply-alb.png)

### 29. ECS Terraform Plan

Terraform plan covering ECS cluster, task definition and service.

![Terraform ECS Plan](screenshots/30-terraform-plan-ecs.png)

### 30. ECS Terraform Apply

ECS resources provisioned successfully, with the application task registered to the target group.

[View screenshot (featured above)](screenshots/31-terraform-apply-ecs.png)

### 31. Cloudflare DNS Updated

The CNAME record updated to point to the Terraform-managed ALB hostname.

![Cloudflare DNS Updated](screenshots/32-cloudflare-dns-updated.png)

### 32. HTTPS Live — Terraform Deployment

The same application successfully redeployed using Terraform-managed AWS infrastructure.

[View screenshot (featured above)](screenshots/33a-terraform-https-home.png)

![Terraform HTTPS Health](screenshots/33b-terraform-https-health.png)

### 33. OIDC Terraform Plan

Terraform plan for GitHub's OIDC provider, IAM role and policy attachment.

![Terraform OIDC Plan](screenshots/34-terraform-plan-oidc.png)

### 34. OIDC Terraform Apply

Historical IAM role and OIDC trust configuration created for GitHub Actions; the published Terraform code was subsequently hardened.

![Terraform OIDC Apply](screenshots/35-terraform-apply-oidc.png)

### 35. GitHub Repository Secret

`AWS_ROLE_ARN` configured as a repository secret for the CI/CD workflows.

![GitHub Secret](screenshots/36-github-secret-added.png)

</details>

<details>
<summary><strong>Phase 4 — GitHub Actions CI/CD (6 evidence entries)</strong></summary>

### 36. Application Pipeline Success

Successful application build and ECR publishing workflow.

![App Pipeline Success](screenshots/37-app-pipeline-success.png)

### 37. Both Pipelines Passing

Historical successful application build and Terraform Apply workflows, before later permission and trigger changes.

[View screenshot (featured above)](screenshots/37b-ci-cd-both-pipelines-green.png)

### 38. Terraform Apply Workflow

Historical Apply workflow steps showing checkout, OIDC authentication, Terraform setup, infrastructure changes and health checking.

![Terraform Apply Workflow](screenshots/38-ci-cd-terraform-apply-detail.png)

### 39. Application Build History

Multiple successful application build workflow runs.

![Application Build History](screenshots/38b-ci-cd-app-build-runs.png)

### 40. Terraform Plan Workflow

Historical pull-request workflow run from before the current split between credential-free PR validation and manual AWS planning.

![Terraform Plan Workflow](screenshots/41-ci-cd-terraform-plan.png)

### 41. Terraform Destroy Workflow

Manually triggered Terraform destroy workflow with explicit confirmation.

![Terraform Destroy Workflow](screenshots/42-ci-cd-terraform-destroy-trigger.png)

</details>

<details>
<summary><strong>Phase 5 — Architecture (1 evidence entry)</strong></summary>

### 42. draw.io Architecture Diagram

Detailed draw.io architecture showing the VPC, public subnets, ALB, ECS Fargate, ECR, ACM, IAM and CI/CD flow.

![draw.io Architecture](screenshots/39b-architecture-drawio.png)

</details>

---

## Engineering Outcomes & Technical Discussion

This project demonstrates the integration of **Go, Docker, AWS ECS, VPC networking, ALB/ACM/Cloudflare, eight Terraform modules, S3 remote state, GitHub Actions, OIDC/IAM and CloudWatch** into a working, verifiable engineering deployment.

The strongest evidence is the sequence: **develop and test the service → containerise it → deploy it on AWS → configure HTTPS and health checks → rebuild infrastructure as code → automate CI/infrastructure operations → investigate failures → strengthen access controls → tear down responsibly**.

The AWS deployment, application health and historical workflow executions are independently evidenced. Later IAM and workflow changes are documented against the current code, with their redeployment requirements made explicit.

**Project provenance:** Completed during the **CoderCo DevOps Engineering programme (January–October 2026)**. The project used real AWS services and professional engineering practices, but was a time-limited hands-on environment rather than commercial production ownership.

### Related Engineering Projects

- [Amazon EKS — Kubernetes, Terraform, GitOps & Monitoring](https://github.com/ismaaeelahmed11/eks-project)
- [Self-Managed Kubernetes — kubeadm & Cluster Operations](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)
- [DevOps Learning — Linux, Bash, AWS, Docker, Terraform, CI/CD & Kubernetes](https://github.com/ismaaeelahmed11/devops-learning)
- [GitHub Profile & Engineering Portfolio](https://github.com/ismaaeelahmed11)

---

**Ismaaeel Ahmed · DevOps Engineer**  
[GitHub Portfolio](https://github.com/ismaaeelahmed11) · [LinkedIn](https://www.linkedin.com/in/ismaaeelahmed) · [Email](mailto:ismaaeelahmed11@gmail.com) · [Technical walkthrough (2:11)](https://youtu.be/qpIZlJkWmos)
