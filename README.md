
# DevOps Engineering | Technical Labs & Infrastructure Automation

**Linux · Bash · Git · Networking · Docker · AWS · Terraform · CI/CD · Kubernetes**

A collection of hands-on engineering work covering Linux administration, scripting, networking, containerisation, cloud infrastructure, CI/CD and Kubernetes.

This repository documents the technical foundations behind my end-to-end AWS projects, including configuration files, automation scripts, infrastructure code and practical exercises.

My focus has been on **building, automating and troubleshooting systems**, not just understanding the tools individually.

The repository also contains my **AWS ECS Fargate project**, where I brought these skills together to build and deploy a containerised application using Terraform, Docker, GitHub Actions and AWS.

---

## Technical Labs

### 01 · Linux & System Administration

**Linux · Ubuntu · Shell · Permissions · Troubleshooting**

Worked directly with Linux systems through command-line administration and practical exercises.

- Managed files, directories, ownership, permissions and processes.
- Used pipes, redirection and command chaining to process output.
- Worked with `grep`, `sed`, `awk` and regular expressions for text processing and inspection.
- Practised file searching, system navigation and command-line troubleshooting.
- Documented **OverTheWire Bandit levels 0–20**, including commands, solutions and screenshots.

**[Explore Linux Labs →](linux/)**

### 02 · Bash Scripting & Automation

**Bash · Shell Scripting · Automation · Error Handling**

Wrote Bash scripts to automate repetitive tasks and develop confidence working directly in the Linux terminal.

- Built scripts for calculations, file operations, permission checks and backups.
- Used variables, loops, conditional statements and functions.
- Worked with user input, exit codes and command execution.
- Used scripting logic to build repeatable workflows and handle errors.

**[Explore Bash Scripts →](bash-scripting/)**

### 03 · Git & Version Control

**Git · GitHub · Branching · Merging · Collaboration Workflows**

Practised Git through repository exercises and version-control scenarios.

- Managed repositories, commits and change history.
- Worked with branches, merges and conflict resolution.
- Used stashing and recovery commands to manage local changes.
- Practised common workflows involving branching and merging.
- Applied Git throughout my infrastructure projects to version-control Terraform, Kubernetes manifests and automation workflows.

**[Explore Git & Version Control Labs →](https://github.com/ismaaeelahmed11/git-labs)**

### 04 · Networking & Connectivity

**TCP/IP · DNS · Subnetting · Routing · Cloudflare**

Worked with networking fundamentals and applied them in a cloud environment.

- Covered the OSI model, TCP/IP, DNS, routing and subnetting.
- Practised network connectivity checks and troubleshooting.
- Deployed **NGINX on Amazon EC2**.
- Configured a custom domain through **Cloudflare DNS**.
- Worked with network addressing and connectivity concepts later used in AWS VPC, load balancing and Kubernetes environments.

**[Explore Networking Labs →](networking/)**

### 05 · Docker & Containerisation

**Docker · Dockerfiles · Docker Compose · Container Registries**

Built and ran containerised applications, progressing from individual containers to multi-service configurations.

- Created container images using Dockerfiles.
- Worked with multi-stage builds and image optimisation.
- Configured a **Flask and Redis application using Docker Compose**.
- Built, tagged and pushed container images to **Docker Hub and Amazon ECR**.
- Practised container lifecycle management, port mapping and image inspection.

These skills were later applied to the AWS ECS Fargate project, where I produced a **4.42 MB Go container image** using a multi-stage Docker build.

**[Explore Docker Labs →](docker/)**

### 06 · AWS Infrastructure

**AWS · EC2 · VPC · Networking · Load Balancing · IAM**

Provisioned and configured AWS resources to understand how cloud infrastructure components work together.

- Configured VPCs, public/private subnets, gateways and route tables.
- Worked with security groups and inbound/outbound networking rules.
- Provisioned EC2 instances using user data.
- Configured **Application Load Balancers**, target groups and health checks.
- Worked with networking and infrastructure components later used in ECS and EKS.

**[Explore AWS Labs →](aws/)**

### 07 · Terraform & Infrastructure as Code

**Terraform · AWS · Modules · State · Cloud-Init**

Used Terraform to provision cloud resources through version-controlled configuration.

- Provisioned a **WordPress environment on Amazon EC2** using Terraform and cloud-init.
- Worked with resources, variables, outputs and Terraform configuration files.
- Practised Terraform commands including `init`, `plan`, `apply` and `destroy`.
- Organised infrastructure using modules.
- Worked with Terraform state and infrastructure lifecycle management.

These foundations were then applied to more complex AWS infrastructure, including an ECS Fargate deployment built using **eight Terraform modules**.

**[Explore Terraform Labs →](terraform/)**

### 08 · CI/CD with GitHub Actions

**GitHub Actions · Automation · Docker · Workflow Triggers**

Built automation workflows to understand how code changes can trigger testing, builds and deployments.

- Created workflows for automated testing and validation.
- Automated Docker image builds and registry publishing.
- Configured workflow secrets and environment variables.
- Worked with manual triggers and matrix builds.
- Practised custom actions and workflow configuration.
- Applied GitHub Actions to real AWS infrastructure and container deployment workflows.

In my ECS project, I implemented **four GitHub Actions workflows** for container publishing, Terraform planning, infrastructure deployment and teardown.

**[Explore CI/CD Workflows →](cicd/)**

### 09 · Kubernetes & Workload Management

**Kubernetes · kubectl · Deployments · Services · Networking**

Worked with Kubernetes resources and container orchestration in local and browser-based environments.

- Created and managed Pods and Deployments.
- Configured Services, ConfigMaps and Secrets.
- Worked with application scaling and workload management.
- Explored Kubernetes storage and networking.
- Practised application deployment and troubleshooting in **Kind and Killercoda** environments.

These exercises provided the foundations for my later AWS EKS project and independently built kubeadm Kubernetes cluster.

**[Explore Kubernetes Exercises →](k8s/exercises/)**

---

## Featured Project in This Repository

### [AWS ECS Fargate — End-to-End Infrastructure & CI/CD](ecs-project/)

**Terraform · Docker · AWS ECS · ECR · ALB · GitHub Actions · OIDC**

Built and deployed an end-to-end, production-style AWS ECS Fargate environment for a containerised Go application.

I first deployed the application manually through the AWS Console to understand how the services connected, then rebuilt the infrastructure using Terraform and automated the deployment workflows through GitHub Actions.

**Engineering implementation**

- Containerised a Go web application using a multi-stage Docker build, producing a **4.42 MB scratch-based image** running as a non-root user.
- Provisioned AWS infrastructure using **eight Terraform modules**, covering networking, ECS, ECR, IAM, security groups, ACM, ALB and OIDC.
- Configured an **Application Load Balancer**, target group and application health checks.
- Implemented HTTPS using **AWS Certificate Manager** and Cloudflare DNS.
- Configured **S3 remote Terraform state with native locking**.
- Built **four GitHub Actions workflows** for image publishing, infrastructure planning, deployment and teardown.
- Used **AWS OIDC authentication** rather than long-lived AWS access keys.
- Integrated **CloudWatch Logs** for application logging and troubleshooting.

**Troubleshooting**

- Resolved an ECS container startup failure caused by privileged port configuration.
- Fixed missing IAM permissions preventing ECS from creating CloudWatch log groups.
- Corrected GitHub Actions workflow placement after workflows failed to trigger.
- Resolved Terraform state-locking compatibility by aligning the CI Terraform version with the backend configuration.

**Outcome:** Successfully deployed the Go application through a custom HTTPS domain, with Terraform-managed infrastructure, automated CI/CD and working health checks.

**[Explore ECS Source Code, Architecture & Troubleshooting →](ecs-project/)**

**[▶ Watch the ECS Project Walkthrough (2:11)](https://youtu.be/qpIZlJkWmos)**

> **Deployment status:** The AWS demonstration resources were removed after completion to avoid ongoing costs. Source code, Terraform configurations, architecture diagrams, CI/CD workflows and deployment evidence remain available in the repository.

---

## Related Engineering Projects

The following projects build on the technical foundations documented in this repository.

### [AWS EKS — End-to-End Kubernetes, GitOps & Monitoring](https://github.com/ismaaeelahmed11/eks-project)

Built an end-to-end, production-style Kubernetes platform on Amazon EKS, using Terraform for infrastructure provisioning and Kubernetes for application orchestration.

- Provisioned an EKS cluster with **four worker nodes across two Availability Zones**.
- Configured NGINX Ingress, cert-manager and ExternalDNS for application routing, HTTPS and DNS.
- Implemented **Argo CD GitOps** for automated application reconciliation.
- Set up **Prometheus and Grafana** for cluster monitoring.
- Built GitHub Actions workflows with AWS OIDC authentication and Checkov/Trivy security scanning.
- Troubleshot persistent storage, IAM permissions, pod scheduling and cluster-access issues.

**[Explore EKS Project →](https://github.com/ismaaeelahmed11/eks-project)** · **[Video Walkthrough (2:29) →](https://youtu.be/RDmnaTi2auE)**

### [Self-Managed Kubernetes — kubeadm & Cluster Operations](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)

Built a two-node Kubernetes cluster independently on Ubuntu virtual machines, working directly with cluster setup and networking rather than relying on a managed Kubernetes service.

- Bootstrapped Kubernetes using **kubeadm and containerd**.
- Configured node networking and **Calico CNI**.
- Deployed NGINX with ClusterIP and NodePort Services.
- Tested scaling, pod self-healing, rolling updates and rollback.
- Investigated virtualisation, cluster bootstrap and access issues.
- Documented the implementation with architecture diagrams, Kubernetes manifests and **19 screenshots**.

**[Explore kubeadm Project →](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)** · **[Video Walkthrough (2:00) →](https://youtu.be/a9hATioCGcs)**

---

## Engineering Approach

Across these labs and projects, I've focused on understanding how systems work before automating them.

- **Build and test:** Start with the fundamentals, validate configurations and confirm that applications work.
- **Automate:** Use Bash, Terraform and GitHub Actions to reduce repetitive manual work.
- **Troubleshoot:** Investigate logs, permissions, networking, application configuration and resource constraints to identify the cause of failures.
- **Document:** Preserve configuration files, commands, architecture diagrams and troubleshooting notes.
- **Apply the fundamentals:** Take the skills developed in individual labs and use them together in end-to-end infrastructure projects.

The ECS, EKS and kubeadm environments demonstrate how these separate technologies connect in practice.

---

## Training & Project Context

Completed the **CoderCo DevOps Engineering programme (January–October 2026)**, covering nine practical modules: Linux, Bash, Git, networking, Docker, AWS, Terraform, CI/CD and Kubernetes.

The ECS and EKS projects were completed as part of the programme, while the kubeadm cluster was built independently to develop a deeper understanding of Kubernetes infrastructure.

These are hands-on portfolio environments using real infrastructure, not claims of commercial production experience.

---

## Explore My Portfolio

For my complete engineering portfolio, project documentation, architecture diagrams and technical walkthroughs:

**[GitHub Engineering Portfolio →](https://github.com/ismaaeelahmed11)**

[LinkedIn](https://www.linkedin.com/in/ismaaeelahmed) · [Email](mailto:ismaaeelahmed11@gmail.com)
