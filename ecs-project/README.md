# AWS ECS Fargate — Production-Grade Infrastructure | Terraform, Docker & CI/CD

**AWS · ECS Fargate · Terraform · Docker · Go · GitHub Actions · IAM/OIDC · ALB · ACM/HTTPS · CloudWatch**

> **Completed production-grade DevOps portfolio project | AWS eu-west-2 (London)**  
> Designed and deployed a containerised Go application using real AWS infrastructure, then recreated the environment as modular Terraform code and added GitHub Actions automation. **The AWS resources have since been destroyed to control costs.** The original hostname, `tm.ismaaeelahmed.co.uk`, is retained as historical deployment evidence, **not a currently running demo**.

**Quick access:** [Technical walkthrough (2:11)](https://youtu.be/qpIZlJkWmos) · [Architecture](#architecture-diagram) · [Deployment proof](#four-screenshots-that-prove-the-main-outcomes) · [Terraform modules](#aws-infrastructure--eight-terraform-modules) · [CI/CD workflows](#cicd--github-actions-oidc--release-boundaries) · [Troubleshooting](#troubleshooting--root-cause-analysis) · [42 evidence stages](#implementation-evidence--42-numbered-stages)

## Project Overview

I **built, deployed and troubleshot an end-to-end Go application on Amazon ECS Fargate**, applying **production-grade engineering practices** across Docker containerisation, Infrastructure as Code (IaC), CI/CD, AWS networking, IAM/OIDC, HTTPS and logging.

I initially provisioned the AWS services manually to understand their dependencies. Once the application was available over HTTPS, I **recreated the environment using eight reusable Terraform modules**, configured **S3 remote state with native locking**, and added **four GitHub Actions workflows** for image publishing and infrastructure operations.

The work is documented through **source code, Terraform configuration, successful workflow runs, architecture diagram, deployment screenshots, a 2:11 video walkthrough and 42 numbered evidence stages**. I include the failures and resolutions—not just the final working application—because debugging the system was an important part of the engineering work.

**What this demonstrates:** I can connect container runtime, AWS infrastructure, load balancing, IAM and CI/CD; validate a working deployment; and investigate problems across service boundaries.

### Outcomes at a Glance

| Area | Completed result |
| --- | --- |
| **Application** | Created a Go HTTP server with `/` and `/health` endpoints |
| **Containerisation** | Multi-stage Docker build; non-root `scratch` runtime image measured at **4.42 MB** |
| **Compute** | Deployed to **Amazon ECS Fargate** with a **0.25 vCPU / 512 MB** task |
| **Networking** | Custom VPC, two public subnets across two Availability Zones, ALB, target group and security groups |
| **HTTPS** | Custom domain via Cloudflare, AWS Certificate Manager, HTTP-to-HTTPS redirect |
| **Infrastructure as Code** | Recreated the deployment with **eight Terraform modules** and S3 remote state |
| **CI/CD** | **Four GitHub Actions workflows**: image build/push, Terraform plan, apply and controlled destroy |
| **Authentication** | GitHub Actions → AWS **OIDC role assumption**, avoiding stored long-lived access keys |
| **Operations** | ALB `/health` checks, CloudWatch application logging and documented incident resolution |
| **Cost control** | Implemented teardown automation and removed the lab infrastructure after completion |

**Scope:** The deployment uses **production-grade engineering practices**—IaC, version control, containerisation, HTTPS, health checks, automated workflows and federated identity. It is a **time-limited technical portfolio environment**, not a commercially operated or fully production-validated service. That distinction does not diminish the engineering work demonstrated here.

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

| **Working application over HTTPS** | **GitHub Actions workflows passed** |
| --- | --- |
| ![Go application served over HTTPS by Terraform-managed ECS](screenshots/33a-terraform-https-home.png) | ![Successful ECS image publishing and infrastructure workflows](screenshots/37b-ci-cd-both-pipelines-green.png) |
| Verified custom domain and TLS following the Terraform rebuild | Successful image-publishing and infrastructure-apply jobs |

| **Terraform applied ECS infrastructure** | **Minimal Docker image built** |
| --- | --- |
| ![Terraform apply creating ECS Fargate resources](screenshots/31-terraform-apply-ecs.png) | ![Docker multi-stage build and 4.42MB image](screenshots/02-dockerbuildfinished-and-filesize.png) |
| ECS cluster/service/task definition created through IaC | Multi-stage build produced a measured 4.42 MB image |

**Evidence interpretation:** A green **App Build & Push** run proves a successful image build and ECR publication; it **does not, by itself, prove automatic ECS service deployment**. The working HTTPS service and Terraform apply are evidenced independently. See [CI/CD design and limitations](#cicd--github-actions-oidc--release-boundaries).

---

## Engineering Skills — Source Code & Evidence

| Skill employers look for | Work demonstrated | Evidence |
| --- | --- | --- |
| **AWS / Cloud engineering** | ECS Fargate, ECR, ALB, ACM, IAM, VPC and CloudWatch | [Terraform modules](terraform/modules/), [AWS deployment evidence](#implementation-evidence) |
| **Terraform / Infrastructure as Code** | Eight modular components, variables, outputs, S3 state and locking | [Terraform source](terraform/), [ECS apply](screenshots/31-terraform-apply-ecs.png) |
| **Docker / containers** | Built a Go binary in a multi-stage image, ran it non-root, tested locally | [Dockerfile](Dockerfile), [Go app](app/main.go), [image-size evidence](screenshots/02-dockerbuildfinished-and-filesize.png) |
| **CI/CD / GitHub Actions** | Image publishing, PR infrastructure plans, apply, manually confirmed destroy | [Repository workflows](../.github/workflows/), [passing workflows](screenshots/37b-ci-cd-both-pipelines-green.png) |
| **Networking** | ALB listeners, target groups, ports, health checks, security groups, DNS | [ALB/Terraform code](terraform/modules/alb/), [HTTPS evidence](screenshots/33a-terraform-https-home.png) |
| **Identity & security** | ECS execution permissions, ACM TLS, GitHub OIDC, SG-restricted application ingress | [IAM module](terraform/modules/iam/), [OIDC module](terraform/modules/oidc/) |
| **Monitoring & operations** | ALB `/health` checks and CloudWatch Logs; diagnosed missing log permissions | [Application endpoint](app/main.go), [IAM incident](#troubleshooting--root-cause-analysis) |
| **Troubleshooting** | Resolved port-binding, logging IAM, Terraform version and workflow discovery problems | [Incident investigations](#troubleshooting--root-cause-analysis) |
| **Cost awareness** | Designed a budget-conscious lab with explicit teardown | [Destroy workflow folder](../.github/workflows/), [teardown evidence](screenshots/42-ci-cd-terraform-destroy-trigger.png) |

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

The four GitHub Actions workflows live at the **repository root**, [`devops-learning/.github/workflows/`](../.github/workflows/). GitHub does **not** discover workflows placed only inside `ecs-project/.github/workflows/`.

| Workflow | Trigger | Demonstrated behaviour |
| --- | --- | --- |
| **ECS App Build & Push** | Push to `main` affecting Go app/Dockerfile | Build container, tag using source revision, push to Amazon ECR |
| **ECS Terraform Plan** | Pull requests affecting Terraform (also invoked manually during demo) | Formatting, initialisation, validation and plan |
| **ECS Terraform Apply** | Push to `main` affecting Terraform | Provision/update infrastructure and run an application health check |
| **ECS Terraform Destroy** | Manual trigger with `destroy` confirmation | Remove Terraform-managed infrastructure |

### Application image pipeline

```text
Application change → GitHub Actions → Docker build → Git commit tag
                   → AWS OIDC credentials → Push image to ECR
```

Tagging with a commit SHA improves image traceability. The image pipeline **builds and publishes** the image; **publishing an image to ECR does not automatically update a running ECS service**. A complete application continuous-deployment pipeline would register a new task definition revision with the published image and update the ECS service, then wait for service stability and verify health. That release step is **not evidenced by the App Build & Push workflow**. The Terraform task definition in the published code also references a specific `:v2` image tag, which is separate from the image-publishing workflow's commit-based tags.

The original ECS service was separately deployed and validated through Terraform. I do not represent the image-publishing workflow as an automatic push-to-production deployment.

### Infrastructure plan, apply and teardown

The **Plan** workflow checks configuration changes before infrastructure modification. The **Apply** workflow assumes the AWS role via OIDC, runs Terraform and performs a health check after applying. The **Destroy** workflow requires a deliberate manual confirmation before removing tracked resources.

OIDC means GitHub Actions does not need persistent AWS access keys. It **does not automatically make the assumed IAM role least-privileged**: the original GitHub Actions role had `AdministratorAccess`, which I would replace with tighter, separate infrastructure and application-deployment roles in a production system.

**CI/CD evidence:** [Successful image pipeline](screenshots/37-app-pipeline-success.png) · [Both workflows green](screenshots/37b-ci-cd-both-pipelines-green.png) · [Apply job steps](screenshots/38-ci-cd-terraform-apply-detail.png) · [PR plan](screenshots/41-ci-cd-terraform-plan.png) · [Destroy confirmation](screenshots/42-ci-cd-terraform-destroy-trigger.png)

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

I have documented the actual failures because **diagnosing the behaviour of a system matters more than only displaying a final green status**.

| Incident | Investigation | Resolution / takeaway |
| --- | --- | --- |
| **Container exited with code 1** | Checked process startup, non-root runtime and application port | Moved Go listener to **8080** and aligned task, target group and security group configuration |
| **CloudWatch log group permission error** | Checked ECS task execution role and Logs access | Granted `logs:CreateLogGroup`; IAM can prevent a task from starting before application traffic reaches it |
| **GitHub Actions workflows did not trigger** | Checked repository layout and workflow discovery path | Relocated YAML files to repository-level `.github/workflows/` |
| **Terraform backend locking failed in CI** | Compared Terraform versions and S3 backend settings | Updated CI from **1.9.0 to 1.11.0** to support `use_lockfile` |
| **ALB/target group conflict** | Inspected existing manually created AWS resources and Terraform resource dependencies | Resolved the conflicting resources and completed ALB/HTTPS provisioning |

### Engineering lessons I can explain in an interview

- **A Docker image building successfully does not guarantee an ECS task will start.** Entrypoint, permissions, container ports, IAM and networking all influence runtime success.
- **An application health check is a full request path.** DNS, ACM, listener rules, target groups, security groups and the container all need to agree.
- **Terraform isn't only about writing HCL.** State, backend versions, ownership of existing resources and deployment ordering matter.
- **A green build pipeline is not automatically a deployment.** Image publication and updating an ECS service are separate operations.
- **Federated AWS authentication reduces credential risk, but IAM policies still need least-privilege review.**

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

## Security, Reliability & Next Engineering Improvements

| Area | What I implemented | What I would improve for a long-running production system |
| --- | --- | --- |
| **Container security** | Non-root minimal `scratch` image | Regular Go/dependency updates, SBOM/signing, vulnerability policy gates |
| **Image registry** | Private ECR repository with scan-on-push | Immutable tags, deployment by image digest, release gates |
| **AWS authentication** | GitHub Actions OIDC; no long-lived AWS keys | Remove broad `AdministratorAccess`, split roles and restrict trust subjects |
| **Network exposure** | ALB HTTPS; ECS accepts inbound traffic from ALB SG | Private task subnets, appropriate VPC endpoints/NAT, network review |
| **Reliability** | ALB health check and two-AZ ALB placement | Multiple ECS tasks across AZs, controlled failover testing, autoscaling |
| **Application delivery** | Automated Docker build/push and Terraform infrastructure apply | Image-to-task-definition release automation, ECS service stability, rollback |
| **Observability** | CloudWatch Logs and basic `/health` | CloudWatch alarms, dashboards, error-rate/latency metrics and runbooks |
| **Testing** | Local `curl`, Docker checks, ALB health and workflow validation | Automated Go tests, smoke tests, integration checks and failure tests |
| **Change control** | Terraform plan on PRs and apply workflow | Branch protection, environment approvals, review gates and policy checks |

**These are design improvements, not features I claim to have implemented.** The portfolio shows I can deliver a working service and also evaluate the controls needed for a more resilient production environment.

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

IAM execution role, task role and policy attachment planned.

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

IAM role and OIDC trust configuration created for GitHub Actions.

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

Successful application build and Terraform Apply workflows.

[View screenshot (featured above)](screenshots/37b-ci-cd-both-pipelines-green.png)

### 38. Terraform Apply Workflow

Workflow steps showing checkout, OIDC authentication, Terraform setup, planning, applying and health checking.

![Terraform Apply Workflow](screenshots/38-ci-cd-terraform-apply-detail.png)

### 39. Application Build History

Multiple successful application build workflow runs.

![Application Build History](screenshots/38b-ci-cd-app-build-runs.png)

### 40. Terraform Plan Workflow

Pull request workflow validating and planning infrastructure changes.

![Terraform Plan Workflow](screenshots/41-ci-cd-terraform-plan.png)

### 41. Terraform Destroy Workflow

Manually triggered Terraform destroy workflow with explicit confirmation.

![Terraform Destroy Workflow](screenshots/42-ci-cd-terraform-destroy-trigger.png)

</details>

<details>
<summary><strong>Phase 5 — Architecture (1 evidence entry)</strong></summary>

### 42. draw.io Architecture Diagram

A detailed architecture diagram showing the VPC, public subnets, ALB, ECS Fargate, ECR, ACM, IAM and CI/CD flow.

![draw.io Architecture](screenshots/39b-architecture-drawio.png)

</details>

---

## Engineering Outcomes & Interview Discussion

This project brings together **Docker, AWS cloud infrastructure, eight modular Terraform components, GitHub Actions CI/CD, IAM/OIDC, DNS/HTTPS, health checks, CloudWatch logging, troubleshooting and cost management** in a single evidence-backed deployment journey.

The strongest evidence is not any single screenshot. It is the sequence: **build and test a container → deploy it on AWS → configure HTTPS and health checks → reproduce the infrastructure as code → automate repeatable operations → investigate failures → tear down responsibly**.

**Project context:** Completed as part of my **CoderCo DevOps Engineering programme (January–October 2026)**. The work used real AWS services but was **not commercial production employment**. I have also completed an [Amazon EKS platform project](https://github.com/ismaaeelahmed11/eks-project) and a [self-managed Kubernetes kubeadm lab](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab).

### Related engineering projects

- [AWS EKS — Kubernetes, Terraform, GitOps & Monitoring](https://github.com/ismaaeelahmed11/eks-project)
- [Self-Managed Kubernetes — kubeadm & Cluster Operations](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)
- [DevOps Engineering Portfolio — Linux, Bash, AWS, Docker, Terraform, CI/CD & Kubernetes](https://github.com/ismaaeelahmed11/devops-learning)

---

**Ismaaeel Ahmed** · DevOps & Cloud Engineering  
[GitHub Portfolio](https://github.com/ismaaeelahmed11) · [LinkedIn](https://www.linkedin.com/in/ismaaeelahmed) · [Email](mailto:ismaaeelahmed11@gmail.com) · [Project walkthrough (2:11)](https://youtu.be/qpIZlJkWmos)
---

**Ismaaeel Ahmed — DevOps & Cloud Engineering**  
[GitHub](https://github.com/ismaaeelahmed11) · [LinkedIn](https://www.linkedin.com/in/ismaaeelahmed) · [Project walkthrough](https://youtu.be/qpIZlJkWmos)
