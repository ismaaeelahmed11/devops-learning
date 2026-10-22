# DevOps Engineering | Technical Labs & Infrastructure Automation

Hands-on implementations across **Linux, Bash, Git, networking, Docker, AWS, Terraform, CI/CD and Kubernetes**.

This repository contains practical exercises, configuration files, automation scripts and infrastructure projects developed through structured DevOps training and hands-on troubleshooting. It documents the technical foundations behind my cloud and Kubernetes engineering work.

**[Explore my full engineering portfolio →](https://github.com/ismaaeelahmed11)**

---

## Repository Overview

| Area | Work documented | Source |
| --- | --- | --- |
| Linux | System administration, permissions, CLI tools, Bandit challenges | [Explore](linux/) |
| Bash | Automation scripts, file operations, backups and error handling | [Explore](bash-scripting/) |
| Git | Branching, merging, history, recovery and repository workflows | [Explore](https://github.com/ismaaeelahmed11/git-labs) |
| Networking | DNS, routing, subnetting and NGINX on EC2 | [Explore](networking/) |
| Docker | Dockerfiles, multi-stage builds, Compose and registries | [Explore](docker/) |
| AWS | VPC networking, EC2, security groups and load balancing | [Explore](aws/) |
| Terraform | Infrastructure as code, cloud-init, modules and state | [Explore](terraform/) |
| CI/CD | GitHub Actions, tests, container builds and workflow automation | [Explore](cicd/) |
| Kubernetes | Workloads, services, configuration, storage and networking | [Explore](k8s/exercises/) |

---

## Technical Implementations

### 01 · Linux & System Administration

- Worked with Linux filesystem navigation, permissions, ownership and process management.
- Used pipes, redirection, regular expressions and command-line text-processing tools.
- Completed **OverTheWire Bandit levels 0–20**, recording commands, solutions and screenshots.

**[View Linux documentation →](linux/)**

### 02 · Bash Scripting & Automation

- Developed scripts for arithmetic operations, file management, permission checks and backups.
- Implemented user input, conditions, loops and exit-code-based error handling.
- Used shell scripting to make recurring command-line tasks repeatable.

**[View Bash scripts →](bash-scripting/)**

### 03 · Git & Version Control

- Practised branching, merging, stashing, commit inspection and undoing changes.
- Worked with repository management and common source-control workflows.

**[View Git labs →](https://github.com/ismaaeelahmed11/git-labs)**

### 04 · Networking & Connectivity

- Covered the OSI model, TCP/IP, DNS resolution, routing and subnetting.
- Investigated connectivity and configuration issues.
- Deployed **NGINX on Amazon EC2** and configured a custom domain through **Cloudflare DNS**.

**[View networking labs →](networking/)**

### 05 · Docker & Containerisation

- Created Dockerfiles and used multi-stage builds to produce container images.
- Configured a multi-container **Flask + Redis** environment with Docker Compose.
- Built, tagged and published images using **Docker Hub** and **Amazon ECR**.

**[View Docker implementations →](docker/)**

### 06 · AWS Cloud Infrastructure

- Configured VPCs with public/private subnets, Internet Gateways, NAT Gateways and security groups.
- Launched EC2 instances with automated initial configuration using user data.
- Worked with **Application Load Balancers**, target groups and health checks.

**[View AWS labs →](aws/)**

### 07 · Terraform & Infrastructure as Code

- Provisioned a **WordPress environment on EC2** using Terraform.
- Automated instance setup using **cloud-init**.
- Worked with variables, outputs, modules and Terraform state management.

**[View Terraform implementations →](terraform/)**

### 08 · CI/CD & GitHub Actions

- Created GitHub Actions workflows for automated testing and container image builds.
- Configured Docker image publishing, manual triggers and matrix builds.
- Worked with workflow secrets and custom actions.

**[View CI/CD workflows →](cicd/)**

### 09 · Kubernetes & Workload Management

- Deployed and configured **Pods, Deployments and Services**.
- Worked with **ConfigMaps, Secrets, storage and Kubernetes networking**.
- Practised orchestration using **Kind** and **Killercoda** before applying these concepts in larger Kubernetes labs.

**[View Kubernetes exercises →](k8s/exercises/)**

---

## Applied Engineering Projects

These projects build on the technical implementations above. Each has its own documentation, architecture and troubleshooting evidence; my [GitHub profile](https://github.com/ismaaeelahmed11) provides the complete portfolio overview.

### AWS ECS Fargate — Infrastructure & Deployment Automation

Containerised a Go application using a **4.42 MB multi-stage/scratch image** and provisioned its AWS environment with **eight Terraform modules**. Implemented an Application Load Balancer, HTTPS using ACM, S3 remote state and **GitHub Actions workflows using OIDC** for AWS authentication.

**[Source code & documentation](ecs-project/)** · **[Video walkthrough (2:11)](https://youtu.be/qpIZlJkWmos)**

### AWS EKS — Kubernetes, GitOps & Monitoring

Built an AWS EKS lab with **Terraform, NGINX Ingress, cert-manager, ExternalDNS, Argo CD, Prometheus and Grafana**, including deployment configuration and troubleshooting documentation.

**Status:** Lab infrastructure has been destroyed to avoid ongoing costs. Deployment IAM policies require appropriate scoped permissions before redeployment.

**[Project repository](https://github.com/ismaaeelahmed11/eks-project)** · **[Video walkthrough (2:29)](https://youtu.be/RDmnaTi2auE)**

### Self-Managed Kubernetes — kubeadm & Cluster Operations

Built a **two-node Kubernetes cluster** on Ubuntu virtual machines using **kubeadm, containerd and Calico**. Tested NGINX deployments, health probes, scaling, self-healing and rolling updates, with documented troubleshooting.

**[Project repository](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)** · **[Video walkthrough (2:00)](https://youtu.be/a9hATioCGcs)**

---

## Engineering Approach

My focus throughout this repository has been on **understanding system behaviour, automating repeatable work and documenting technical decisions**. The labs connect Linux and networking fundamentals with infrastructure provisioning, container delivery and Kubernetes operations.

This work complements my professional background in **IT Support & Operations**, where troubleshooting and systematic problem-solving are central to day-to-day work.

---

## Connect

- **[GitHub engineering portfolio](https://github.com/ismaaeelahmed11)**
- **[LinkedIn — Ismaaeel Ahmed](https://www.linkedin.com/in/ismaaeelahmed/)**
