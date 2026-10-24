# AWS ECS Fargate — End-to-End Production-Grade Infrastructure & CI/CD

**AWS · Terraform · Docker · ECS Fargate · GitHub Actions · OIDC · CloudWatch**

Built and deployed an **end-to-end AWS ECS Fargate environment**, applying **production-grade engineering practices** across infrastructure as code, containerisation, CI/CD, HTTPS, logging and troubleshooting.

The project covers the complete delivery process: developing and containerising an application, configuring AWS infrastructure, implementing HTTPS, managing infrastructure as code, setting up CI/CD pipelines and troubleshooting deployment issues.

I initially built the infrastructure manually through the AWS Console to understand how the services connected, then recreated it using **eight Terraform modules** before automating the deployment workflows.

**Project outcome:** Successfully deployed a Go application on AWS ECS Fargate with a custom HTTPS domain, a 4.42 MB container image, modular Terraform infrastructure, four GitHub Actions workflows, CloudWatch logging and working application health checks.

> **Deployment status:** The application was deployed and demonstrated at `https://tm.ismaaeelahmed.co.uk`. AWS resources were destroyed after completion to avoid ongoing charges. The URL is retained as deployment evidence, not as a currently available service.

---

## Project Walkthrough

A technical walkthrough covering the AWS architecture, Terraform infrastructure, Docker containerisation, GitHub Actions CI/CD and troubleshooting.

[![Watch the AWS ECS Fargate Project Walkthrough](https://img.youtube.com/vi/qpIZlJkWmos/hqdefault.jpg)](https://youtu.be/qpIZlJkWmos)

**[▶ Watch the AWS ECS Fargate Project Walkthrough (2:11)](https://youtu.be/qpIZlJkWmos)**

---

## Architecture

![AWS ECS Fargate Architecture](screenshots/39b-architecture-drawio.png)

### How the infrastructure works

**Application traffic**

1. A user visits `tm.ismaaeelahmed.co.uk`.
2. Cloudflare DNS resolves the hostname to the AWS Application Load Balancer.
3. HTTP traffic is redirected to HTTPS.
4. The ALB terminates TLS using an AWS Certificate Manager certificate.
5. The HTTPS listener forwards traffic to the target group.
6. The target group routes requests to the ECS Fargate task on port `8080`.
7. The containerised Go application responds to the request.

The ALB also performs health checks against the application's `/health` endpoint.

**Infrastructure and deployment**

- **Terraform** provisions the VPC, networking, security groups, IAM roles, ECR, load balancer and ECS infrastructure.
- **Amazon ECR** stores the Docker image.
- **Amazon ECS Fargate** runs the container without requiring EC2 worker-node management.
- **GitHub Actions** automates image publishing, Terraform planning, infrastructure deployment and teardown.
- **AWS OIDC federation** allows GitHub Actions to assume an IAM role without storing long-lived AWS access keys.
- **CloudWatch Logs** captures application logs for troubleshooting.

The deployment used two public subnets across two Availability Zones for the load balancer and ECS networking. The demonstrated ECS task ran in a public subnet, with inbound application access restricted through its security group.

---

## Deployment Evidence — At a Glance

These four screenshots show the main outcomes immediately. The full **43-stage evidence log** is organised by project phase in [Implementation Evidence](#implementation-evidence).

### Container image — 4.42 MB

A successful multi-stage Docker build produced a minimal scratch-based Go container image.

![Docker multi-stage build and final image size](screenshots/02-dockerbuildfinished-and-filesize.png)

### Terraform-managed ECS deployment

Terraform successfully provisioned the ECS cluster, task definition and service, with the task registered to the target group.

![Terraform ECS apply successful](screenshots/31-terraform-apply-ecs.png)

### Application accessible over HTTPS

The Go application was successfully accessed through the custom domain after rebuilding the infrastructure using Terraform.

![Go application served over HTTPS from Terraform-managed infrastructure](screenshots/33a-terraform-https-home.png)

### CI/CD workflows passing

The GitHub Actions image build and Terraform infrastructure workflows completed successfully.

![GitHub Actions app and Terraform pipelines passing](screenshots/37b-ci-cd-both-pipelines-green.png)

---

## Infrastructure Overview

| Component | Implementation |
| --- | --- |
| **AWS Region** | `eu-west-2` — London |
| **Application** | Go HTTP web server |
| **Endpoints** | `/` and `/health` |
| **Container** | Multi-stage Docker build, scratch-based final image |
| **Image Size** | 4.42 MB |
| **Container Registry** | Amazon ECR with scan-on-push |
| **Compute** | ECS Fargate |
| **Task Resources** | 0.25 vCPU, 512 MB memory |
| **Networking** | Custom VPC, two public subnets across two AZs |
| **Load Balancing** | Application Load Balancer |
| **Application Port** | `8080` |
| **TLS/HTTPS** | AWS Certificate Manager |
| **DNS** | Cloudflare |
| **Infrastructure as Code** | Terraform — eight modules |
| **Terraform State** | S3 remote backend with native locking |
| **CI/CD** | Four GitHub Actions workflows |
| **AWS Authentication** | OIDC federation |
| **Logging** | Amazon CloudWatch Logs |

The environment uses **production-grade engineering practices** such as modular infrastructure as code, CI/CD, OIDC authentication, HTTPS and logging. It was a time-limited portfolio deployment, not a commercially operated or fully production-validated system.

---

## Engineering Decisions

### Why a Go application?

I used a deliberately small Go web server with two endpoints:

| Endpoint | Purpose |
| --- | --- |
| `/` | Returns an application welcome message |
| `/health` | Returns `{"status":"ok"}` for health checks |

The application is intentionally simple because the main engineering work is the infrastructure and automation around it.

Go was useful for this project because it can compile into a standalone binary, allowing me to create a small container image without including a full Linux distribution or application runtime.

### Why a multi-stage Docker build?

The Dockerfile uses a build stage to compile the Go application, then copies the resulting binary into a minimal `scratch` image.

This produced a **4.42 MB final image**.

The container was also configured to run as a non-root user.

Advantages of this approach include:

- A smaller image with fewer unnecessary components
- Reduced image transfer and storage overhead
- No package manager or shell in the final container
- A smaller container attack surface
- A simple runtime environment for the application

I validated the application locally before packaging it into a container, and tested the container before deploying it to AWS.

### Why ECS Fargate?

The objective was to understand AWS-native container orchestration and application deployment.

ECS Fargate allowed me to work with container scheduling, task definitions, networking, IAM permissions, load balancing, health checks and logging without managing the underlying EC2 hosts.

Compared with running Docker directly on a virtual machine, Fargate handles the host infrastructure while I remain responsible for configuring the application, task resources, networking, security and deployment behaviour.

This was also a useful step between working with Docker locally and subsequently building a Kubernetes platform on AWS EKS.

### Why ClickOps before Terraform?

One of the main decisions was to build the environment manually before automating it.

I first created and connected the AWS services using the Console and CLI, including:

- ECR repository
- ECS cluster and task definition
- Target group
- Application Load Balancer
- Security configuration
- ACM certificate
- Cloudflare DNS record

Once the application was working over HTTPS, I recreated the infrastructure using Terraform.

This helped me understand what Terraform was provisioning rather than treating the infrastructure as a collection of configuration files.

### Why eight Terraform modules?

I separated infrastructure responsibilities into reusable modules instead of putting every resource into a single Terraform file.

The modules cover:

1. VPC networking
2. ECR
3. Security groups
4. IAM
5. ACM
6. ALB
7. ECS
8. OIDC

This made the infrastructure easier to organise, understand, change and troubleshoot.

### Scaling and availability

The deployment uses an Application Load Balancer across two Availability Zones, with ECS Fargate handling task execution.

ECS supports service scaling and distributing tasks across Availability Zones, but these capabilities require appropriate service configuration and task capacity.

The demonstration was not a fully tested high-availability environment. Running a single task does not provide application redundancy.

For a higher-availability deployment, I would use multiple tasks distributed across Availability Zones, configure ECS Service Auto Scaling and test task replacement and failure recovery.

---

## Project Structure

```text
ecs-project/
├── app/
│   ├── main.go
│   └── go.mod
│
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
│
├── screenshots/
├── Dockerfile
├── .dockerignore
├── .gitignore
└── README.md
```

**CI/CD workflows:** The GitHub Actions workflow files are stored in the `devops-learning` repository's root `.github/workflows/` directory, rather than inside `ecs-project/`.

GitHub discovers workflow definitions from the repository-level workflows directory.

---

## Phase 1 — Local Application & Containerisation

### Prerequisites

For local development:

- Go 1.23 or a compatible version
- Docker

For AWS deployment:

- Terraform compatible with the repository configuration
- AWS CLI configured
- AWS account and appropriate permissions
- Cloudflare-managed domain
- Existing ACM certificate and Terraform backend configuration

### Clone the repository

```bash
git clone https://github.com/ismaaeelahmed11/devops-learning.git

cd devops-learning/ecs-project
```

### Run the Go application

From the `ecs-project` directory:

```bash
cd app

go run main.go
```

The application listens on port `8080`.

Test the health endpoint:

```bash
curl http://localhost:8080/health
```

Expected response:

```json
{"status":"ok"}
```

Return to the project directory:

```bash
cd ..
```

### Build the Docker image

From the `ecs-project` directory:

```bash
docker build -t ecs-project:v1 .
```

Inspect the image:

```bash
docker images ecs-project
```

The final image created during the project was approximately **4.42 MB**.

### Run the container locally

```bash
docker run --rm -p 8080:8080 ecs-project:v1
```

In another terminal:

```bash
curl http://localhost:8080/

curl http://localhost:8080/health
```

This verifies the container independently of AWS before moving into cloud deployment.

---

## Phase 2 — Manual AWS Deployment

Before using Terraform, I configured and deployed the environment manually through the AWS Console and CLI.

This stage helped establish how the individual services communicate.

### 1. Container registry

Created a private ECR repository and pushed the Docker image.

This provided a registry from which ECS could pull the application image.

### 2. ECS cluster and task definition

Created the ECS cluster and configured a Fargate task definition using:

- 0.25 vCPU
- 512 MB memory
- Container port `8080`
- CloudWatch logging configuration

### 3. Application networking

Created an Application Load Balancer and target group.

The target group used:

- Target type: `ip`
- Port: `8080`
- Health check path: `/health`

The ECS task was registered with the target group so the ALB could forward requests to the container.

### 4. HTTPS

Requested an AWS Certificate Manager certificate for:

`tm.ismaaeelahmed.co.uk`

Validated the certificate using Cloudflare DNS.

Configured the ALB listeners to:

- Redirect HTTP requests on port `80` to HTTPS
- Accept HTTPS traffic on port `443`
- Forward HTTPS requests to the application target group

### 5. DNS

Created a Cloudflare CNAME record pointing the application hostname to the ALB DNS name.

### Result

The application was successfully accessible through its custom HTTPS domain, and both application endpoints responded correctly.

This established a working manual deployment before the infrastructure was recreated with Terraform.

---

## Phase 3 — Infrastructure as Code with Terraform

After completing the manual deployment, I reproduced the AWS infrastructure using **eight Terraform modules**.

### VPC networking

The Terraform VPC configuration included:

- Custom VPC
- Internet Gateway
- Two public subnets
- Public route table
- Route table associations

The demonstrated environment did not require a NAT Gateway because the ECS tasks ran in public subnets.

### Security groups

Two security groups were configured:

**ALB security group**

- Accepts external HTTP traffic on port `80`
- Accepts external HTTPS traffic on port `443`

**ECS service security group**

- Allows application traffic on port `8080` from the ALB security group

This restricts direct inbound application traffic, although public-subnet deployment still requires appropriate review of network exposure and outbound access.

### IAM

IAM roles were configured for ECS task execution and application requirements.

A CloudWatch Logs permission issue was identified during deployment and resolved by adding the necessary permission to create the log group.

### ACM

Terraform used a data source to look up the existing ACM certificate.

The certificate ARN was then passed to the ALB module.

This avoided creating another certificate when an appropriate certificate already existed.

### ALB

Terraform provisioned:

- Application Load Balancer
- Target group
- HTTP listener
- HTTPS listener

The HTTP listener redirects to HTTPS, while the HTTPS listener forwards traffic to the ECS target group.

### ECS

Terraform provisioned the ECS cluster, task definition and service.

The service runs the container image from ECR and connects the task to the ALB target group.

### S3 remote state

The Terraform state backend uses Amazon S3.

The state bucket was configured with:

- Versioning
- Encryption
- Public access blocked
- Native Terraform state locking

Remote state allowed the infrastructure to be managed through local Terraform commands and GitHub Actions workflows.

### Terraform commands

From the `ecs-project` directory:

```bash
cd terraform

terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

Review the proposed changes carefully before approving the apply operation.

### Terraform outputs

Useful outputs include:

- `alb_dns_name` — the public ALB hostname
- `ecr_repository_url` — the container registry URL

### Deployment considerations

The Terraform backend and required ACM certificate must already be configured.

The ECS application also requires a suitable container image to be available in ECR.

The original environment was successfully deployed, but rebuilding it requires checking the current Terraform variables, module configuration, AWS permissions and deployment order.

The original AWS resources are no longer running.

---

## Phase 4 — CI/CD Automation

Once the Terraform-managed deployment was working, I implemented **four GitHub Actions workflows**.

This allowed infrastructure changes and application image publishing to be managed through GitHub rather than relying only on local commands.

| Workflow | Trigger | Responsibility |
| --- | --- | --- |
| **ECS App Build & Push** | Push to `main` affecting the application or Dockerfile | Build image, tag with commit SHA, push to ECR |
| **ECS Terraform Plan** | Pull request affecting Terraform | Format check, init, validate and plan |
| **ECS Terraform Apply** | Push to `main` affecting Terraform | Provision or update infrastructure and run health check |
| **ECS Terraform Destroy** | Manual trigger | Destroy Terraform-managed infrastructure |

### Application pipeline

The application workflow:

1. Checks out the repository.
2. Configures AWS access.
3. Builds the Docker image.
4. Tags the image using the commit SHA.
5. Authenticates to Amazon ECR.
6. Pushes the image to the registry.

Tagging with the commit SHA helps identify which source revision produced an image.

### Terraform plan pipeline

The Terraform Plan workflow runs against pull requests.

It checks the Terraform configuration before infrastructure changes are merged.

The workflow includes:

```bash
terraform fmt -check
terraform init
terraform validate
terraform plan
```

This provides an opportunity to review the proposed infrastructure changes without automatically applying them.

### Terraform apply pipeline

The Terraform Apply workflow runs when the configured Terraform paths change on `main`.

The workflow includes:

- Repository checkout
- AWS authentication using OIDC
- Terraform setup
- Terraform initialisation
- Terraform plan
- Terraform apply
- Post-deployment health check

### Terraform destroy pipeline

The destroy workflow is manually triggered and requires entering `destroy` to confirm the operation.

This introduces an explicit confirmation step before the teardown process.

The workflow was used as part of the project's cost-management approach.

### AWS authentication with OIDC

GitHub Actions authenticates to AWS using OpenID Connect rather than stored, long-lived AWS access keys.

The repository uses `AWS_ROLE_ARN` to identify the IAM role that GitHub Actions should assume.

The role trust policy controls which GitHub identity claims are accepted.

**Security note:** The original infrastructure evidence shows an `AdministratorAccess` policy attached to the GitHub Actions role. Although OIDC avoids permanent AWS credentials, that policy grants broad permissions. A production deployment should replace it with more narrowly scoped IAM permissions and tightly restricted trust conditions.

### Pipeline result

The infrastructure deployment and application build workflows completed successfully during the demonstration.

The repository preserves workflow screenshots and execution history as evidence.

---

## Application Health Checks & Logging

### HTTP health endpoint

The Go application exposes:

```text
GET /health
```

Response:

```json
{"status":"ok"}
```

The ALB target group uses this endpoint to determine whether the target responds successfully.

### CloudWatch Logs

The ECS task was configured to publish application logs to Amazon CloudWatch.

During implementation, a missing IAM permission prevented the task from creating the expected log group.

I investigated the task execution permissions and added `logs:CreateLogGroup` to resolve the issue.

This reinforced the distinction between configuring a logging destination and granting the ECS execution role permission to use it.

---

## Troubleshooting & Root Cause Analysis

Several real configuration and deployment issues occurred during the project.

These were documented because understanding failures and resolving them was a key part of the engineering work.

### 1. Container exited with code 1

**Problem:** The application container exited during the initial deployment.

**Investigation:** Reviewed the container's listening port and the non-root execution configuration.

**Root cause:** The application attempted to bind to port `80`, a privileged port under the container's runtime configuration.

**Resolution:** Changed the application to use port `8080` and updated the ECS task definition, target group and security group configuration.

**Takeaway:** The application port, container port mappings, target group configuration and network permissions must align.

### 2. ECS task could not create the CloudWatch log group

**Problem:** The ECS task encountered a logging-related permission error.

**Investigation:** Examined the task execution role and CloudWatch Logs permissions.

**Root cause:** The execution role lacked `logs:CreateLogGroup`.

**Resolution:** Added an inline IAM policy granting the required permission.

**Takeaway:** ECS requires the appropriate IAM execution permissions to pull images and publish logs. A service can fail before the application starts if supporting permissions are missing.

### 3. GitHub Actions workflows did not trigger

**Problem:** GitHub Actions workflows were not running after code changes.

**Investigation:** Checked workflow placement and GitHub's repository workflow discovery rules.

**Root cause:** The files had been placed in:

```text
ecs-project/.github/workflows/
```

GitHub Actions discovers workflow files from the repository root:

```text
.github/workflows/
```

**Resolution:** Moved the workflows to the correct repository-level directory.

**Takeaway:** In a repository containing multiple project folders, GitHub Actions workflow location matters regardless of the project being automated.

### 4. Terraform `use_lockfile` was unsupported

**Problem:** Terraform initialisation failed in CI after introducing the S3 backend's `use_lockfile` configuration.

**Investigation:** Compared the local Terraform configuration with the version installed in GitHub Actions.

**Root cause:** CI was using Terraform `1.9.0`, which did not support the backend option.

**Resolution:** Updated the CI Terraform version to `1.11.0`.

**Takeaway:** Infrastructure automation needs consistent, compatible tool versions between local development and CI.

### 5. ALB target group conflict during Terraform provisioning

**Problem:** An ALB-related resource conflict occurred while recreating the infrastructure with Terraform.

**Investigation:** Reviewed the load-balancer configuration and previously created AWS resources.

**Resolution:** Resolved the target group conflict before completing the HTTPS listener configuration.

**Takeaway:** Rebuilding manually created infrastructure using Terraform requires attention to resource ownership, existing cloud resources and configuration dependencies.

### Troubleshooting approach

Across these incidents, I worked through the actual service configuration and error messages rather than repeatedly retrying deployments.

The main areas involved were:

- Container runtime permissions
- ECS task definitions
- Load balancer and target group configuration
- AWS IAM permissions
- GitHub Actions workflow configuration
- Terraform version compatibility
- Infrastructure resource dependencies

These issues demonstrated how application behaviour often depends on the surrounding infrastructure rather than just the application code.

---

## Implementation Evidence

The **43 numbered evidence entries** below document the five phases of the project: local development, manual AWS deployment, Terraform provisioning, GitHub Actions and architecture. Four key screenshots are shown immediately after the architecture; their original evidence entries link to those same images rather than displaying them twice.

The evidence records what was configured, deployed, tested and troubleshot.

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
<summary><strong>Phase 5 — Architecture (2 evidence entries)</strong></summary>

### 42. Mermaid Architecture Diagram

An architecture diagram documenting the AWS components and their connections.

![Mermaid Architecture](screenshots/39a-architecture-mermaid.png)

### 43. draw.io Architecture Diagram

A detailed architecture diagram showing the VPC, public subnets, ALB, ECS Fargate, ECR, ACM, IAM and CI/CD flow.

![draw.io Architecture](screenshots/39b-architecture-drawio.png)

</details>

---

## Security Considerations & Future Improvements

The project implements several security-related practices:

- Container running as a non-root user
- Minimal scratch-based runtime image
- ECR image scanning
- HTTPS using AWS Certificate Manager
- ECS inbound application access restricted to the ALB security group
- GitHub Actions authentication through OIDC
- S3 state bucket encryption and public access blocking

There are also improvements I would make before considering a similar system ready for long-term production use.

### 1. Reduce GitHub Actions IAM permissions

The original GitHub Actions role used `AdministratorAccess`.

I would replace this with role-specific permissions for Terraform provisioning, ECR image publishing and ECS deployment.

Where possible, separate infrastructure administration permissions from application deployment permissions.

### 2. Use private subnets for ECS tasks

The original deployment used public subnets to keep the lab simpler and avoid NAT Gateway costs.

For a production-oriented design, I would place ECS tasks in private subnets with suitable outbound connectivity or VPC endpoints.

The ALB would remain publicly accessible.

### 3. Add ECS Service Auto Scaling

I would configure ECS Service Auto Scaling using appropriate CPU, memory or application metrics.

This would allow task capacity to respond to workload demand rather than relying only on manual changes to `desired_count`.

### 4. Test multi-AZ application availability

I would run multiple ECS tasks across Availability Zones and perform controlled failure tests.

This would provide actual evidence of recovery behaviour rather than assuming high availability from the subnet configuration.

### 5. Improve deployment validation

I would add automated application tests, deployment validation and rollback procedures.

These would help detect failures beyond the existing basic health endpoint.

### 6. Expand monitoring

I would add CloudWatch alarms for unhealthy ALB targets, ECS task failures and relevant performance metrics.

Alerts and runbooks would make the infrastructure easier to operate during an incident.

These improvements are future work, not capabilities claimed to have been implemented in the original deployment.

---

## Cost Management

The ECS environment was created for a time-limited technical project.

Running AWS resources such as an Application Load Balancer and ECS Fargate tasks can generate ongoing charges even when no one is actively using the application.

To manage costs, I:

- Built the environment for the demonstration period.
- Used Terraform to manage infrastructure creation and removal.
- Implemented a manually triggered teardown workflow.
- Removed the AWS resources after completing the project.
- Preserved the configuration, architecture diagrams and deployment evidence in GitHub.

The infrastructure is no longer running, but the implementation remains available for review.

Before rebuilding the environment, current AWS pricing, IAM permissions, Terraform dependencies and existing resources should be checked.

---

## What This Project Demonstrates

This project combines the full infrastructure deployment process with practical troubleshooting.

The main engineering areas demonstrated were:

- **Containerisation:** Building and validating a small Go application in Docker.
- **AWS infrastructure:** Configuring ECS, ECR, VPC networking, load balancing, IAM, ACM and CloudWatch.
- **Terraform:** Rebuilding manually configured infrastructure as modular, version-controlled code.
- **CI/CD:** Automating image publishing, infrastructure planning, deployment and teardown.
- **Authentication:** Using OIDC to avoid storing long-lived AWS access keys in GitHub Actions.
- **Networking:** Connecting DNS, ALB listeners, target groups, security groups and container ports.
- **Troubleshooting:** Resolving real container runtime, IAM, CI/CD and Terraform configuration issues.
- **Cost awareness:** Removing cloud resources when they are no longer needed.

The most valuable part of building this project was seeing how the components depend on one another.

A container can work locally but fail on ECS because of permissions, networking or task configuration. A Terraform configuration can work locally but fail in CI because the tool versions differ.

Understanding those dependencies was as important as getting the application online.

---

## Project Context

This project was completed as part of my **CoderCo DevOps Engineering programme (January–October 2026)**.

It is an end-to-end AWS engineering project built using real cloud infrastructure and **production-grade engineering practices**. It was not operated as a commercial production service, nor was the environment validated against every production-readiness requirement.

The AWS demonstration resources were removed after completion to avoid ongoing costs.

The source code, Terraform modules, architecture diagrams, deployment workflows and troubleshooting evidence remain available in this repository.

### Related engineering projects

- [AWS EKS — End-to-End Production-Grade Kubernetes, GitOps & Monitoring](https://github.com/ismaaeelahmed11/eks-project)
- [Self-Managed Kubernetes — kubeadm & Cluster Operations](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)
- [Main DevOps Engineering Portfolio](https://github.com/ismaaeelahmed11)

---

## Connect

**Ismaaeel Ahmed — DevOps & Cloud Engineering**

[LinkedIn](https://www.linkedin.com/in/ismaaeelahmed) · [GitHub](https://github.com/ismaaeelahmed11) · [Email](mailto:ismaaeelahmed11@gmail.com)
