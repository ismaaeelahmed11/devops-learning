
# DevOps Engineering | Technical Implementations

A collection of hands-on work across **Linux, Bash, Git, networking, Docker, AWS, Terraform, CI/CD and Kubernetes**.

This repository contains configuration files, scripts, infrastructure code and technical notes from practical engineering labs. The focus is on **implementing, automating and troubleshooting systems**, with links to the work in each area.

## Technical Labs

### 01. Linux & System Administration

- Managed files, permissions, ownership and processes from the Linux command line.
- Used pipes, redirection, `grep`, `sed`, `awk` and regular expressions for inspection and text processing.
- Documented **OverTheWire Bandit levels 0–20** with commands, solutions and screenshots.

**[Explore Linux labs](linux/)**

### 02. Bash Scripting & Automation

- Wrote scripts for calculations, file operations, permission checks and backups.
- Used variables, loops, conditionals, user input and exit codes to build repeatable workflows and handle errors.

**[Explore Bash scripts](bash-scripting/)**

### 03. Git & Version Control

- Worked with branching, merging, stashing, commit history and change recovery.
- Applied Git workflows through practical repository exercises.

**[Explore Git labs](https://github.com/ismaaeelahmed11/git-labs)**

### 04. Networking & Connectivity

- Worked with the OSI model, TCP/IP, DNS, routing, subnetting and connectivity troubleshooting.
- Deployed **NGINX on Amazon EC2** and configured a custom domain through **Cloudflare DNS**.

**[Explore networking labs](networking/)**

### 05. Docker & Containerisation

- Built container images using Dockerfiles and multi-stage builds.
- Configured a **Flask + Redis** application with Docker Compose.
- Built, tagged and pushed images to **Docker Hub** and **Amazon ECR**.

**[Explore Docker labs](docker/)**

### 06. AWS Infrastructure

- Configured VPCs, public/private subnets, gateways, route tables and security groups.
- Provisioned EC2 instances using user data and configured **Application Load Balancers**, target groups and health checks.

**[Explore AWS labs](aws/)**

### 07. Terraform & Infrastructure as Code

- Provisioned a **WordPress environment on EC2** using Terraform and cloud-init.
- Organised infrastructure using variables, outputs, modules and Terraform state.

**[Explore Terraform labs](terraform/)**

### 08. CI/CD with GitHub Actions

- Implemented workflows for automated tests, Docker image builds and registry publishing.
- Configured workflow secrets, manual triggers, matrix builds and custom actions.

**[Explore CI/CD workflows](cicd/)**

### 09. Kubernetes & Workload Management

- Configured Pods, Deployments, Services, ConfigMaps and Secrets.
- Worked with storage, networking and application workloads in **Kind** and **Killercoda** environments.

**[Explore Kubernetes exercises](k8s/exercises/)**

---

## Project in This Repository

### AWS ECS Fargate | Containerised Application & Infrastructure Automation

Built a containerised Go application and provisioned its AWS infrastructure using **Terraform**.

- Produced a **4.42 MB** Go container image using a multi-stage build and a `scratch` runtime image.
- Provisioned **ECS Fargate**, VPC networking and an **Application Load Balancer** using **eight Terraform modules**.
- Configured HTTPS with **AWS Certificate Manager**, application health checks and **CloudWatch** logging.
- Used **S3 remote Terraform state with native locking**.
- Implemented **four GitHub Actions workflows** for image publishing and infrastructure operations, using **AWS OIDC** rather than long-lived access keys.

**[Source code & project documentation](ecs-project/)** · **[Video walkthrough (2:11)](https://youtu.be/qpIZlJkWmos)**

> The AWS lab infrastructure was destroyed after testing to avoid ongoing costs. The implementation and documentation remain available in this repository.

---

## Related Engineering Projects

These projects have their own repositories, architecture diagrams and implementation documentation:

- **[AWS EKS | Kubernetes, GitOps & Monitoring](https://github.com/ismaaeelahmed11/eks-project)** — Terraform-provisioned EKS, NGINX Ingress, cert-manager, ExternalDNS, Argo CD, Prometheus and Grafana.
- **[Self-Managed Kubernetes | kubeadm Cluster](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)** — Two-node Ubuntu cluster with containerd and Calico; deployment scaling, health checks, self-healing and rollouts.

**[View the complete engineering portfolio](https://github.com/ismaaeelahmed11)**
