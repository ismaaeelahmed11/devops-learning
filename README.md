# DevOps Engineering Portfolio | AWS, Terraform, Kubernetes & CI/CD

**Linux · Bash · Git · Networking · Docker · AWS · Terraform · GitHub Actions · Kubernetes · GitOps · Observability**

I'm a UK-based aspiring **DevOps / Cloud Engineer** with hands-on experience building, automating and troubleshooting cloud infrastructure and Kubernetes environments. My work spans **AWS ECS Fargate, Amazon EKS and self-managed Kubernetes with kubeadm**, supported by practical labs in Linux, scripting, version control, networking, Docker, Terraform and CI/CD.

This repository is the **technical foundation and project hub** of my portfolio. It contains working configurations, scripts, infrastructure code, GitHub Actions workflows, architecture diagrams and captured deployment evidence—not just a list of technologies studied.

**What I focus on:** infrastructure as code, repeatable delivery, secure access, service networking, observability, diagnosing failures and documenting why an engineering decision was made.

> **Project status:** My AWS ECS and EKS environments were successfully deployed and demonstrated, then deliberately destroyed to control costs. Their historical URLs are **not live demos**. The kubeadm project is a local VirtualBox-based cluster lab. Source code, screenshots and video walkthroughs remain available for review.

**[ECS Fargate](#1-aws-ecs-fargate--terraform-docker--cicd)** · **[Amazon EKS](#2-amazon-eks--kubernetes-gitops--observability)** · **[Self-managed kubeadm](#3-self-managed-kubernetes--kubeadm--linux)** · **[Technical labs](#technical-foundations--nine-hands-on-modules)** · **[Troubleshooting](#engineering-problem-solving--real-issues-resolved)**

---

## Featured Engineering Projects

These three projects demonstrate complementary skills: **deploying containerised applications on AWS**, **integrating a managed Kubernetes platform**, and **administering Kubernetes directly on Linux VMs**.

| Project | What I built | Key evidence |
| --- | --- | --- |
| **[AWS ECS Fargate](ecs-project/)** | Go application on ECS Fargate; eight Terraform modules; Docker, ECR, ALB, HTTPS, OIDC, GitHub Actions and CloudWatch | **4.42 MB** container image; successful Terraform-managed HTTPS deployment; **four** GitHub Actions workflows |
| **[Amazon EKS](https://github.com/ismaaeelahmed11/eks-project)** | AWS Kubernetes environment with Terraform, NGINX Ingress, cert-manager, ExternalDNS, Argo CD and Prometheus/Grafana | **Two** IT-Tools replicas; Argo CD **Synced / Healthy**; Grafana metrics; working HTTPS application |
| **[Self-managed Kubernetes](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)** | Two Ubuntu VMs using kubeadm, containerd and Calico; NGINX Deployments and Services | **Two Ready nodes**; **four** NGINX replicas; demonstrated Pod replacement, rolling updates and rollback |

### 1. AWS ECS Fargate — Terraform, Docker & CI/CD

**AWS ECS · ECR · Go · Docker · Terraform · ALB · ACM · Cloudflare · GitHub Actions · OIDC · CloudWatch**

I developed a small **Go HTTP application**, containerised it with a multi-stage Dockerfile, deployed it onto **Amazon ECS Fargate**, exposed it over **HTTPS** using an Application Load Balancer and ACM, and configured application health checking and CloudWatch logging.

I first built the infrastructure manually to understand the AWS services and their dependencies, then rebuilt it using **eight Terraform modules** with S3 remote state. I also implemented **four GitHub Actions workflows** covering container-image publishing, Terraform planning, infrastructure apply and controlled teardown.

**Engineering highlights**

- Built a **4.42 MB**, non-root, `scratch`-based Go image; published images to **Amazon ECR**.
- Configured a VPC with two public subnets, ALB listeners, an IP target group, `/health` checks, ACM TLS and Cloudflare DNS.
- Used **GitHub Actions OIDC** to assume an AWS role without storing long-lived AWS access keys.
- Resolved container startup, CloudWatch IAM, Terraform version/state-locking and GitHub Actions workflow issues.
- Deployed and tested the application at `tm.ismaaeelahmed.co.uk` before tearing down AWS resources.

**Deployment proof — application over HTTPS**

![Go application served over HTTPS from Terraform-managed AWS ECS Fargate](ecs-project/screenshots/33a-terraform-https-home.png)

**[View the complete ECS technical README and source](ecs-project/)** · **[Architecture diagram](ecs-project/screenshots/39b-architecture-drawio.png)** · **[Passing workflows](ecs-project/screenshots/37b-ci-cd-both-pipelines-green.png)** · **[Terraform ECS apply](ecs-project/screenshots/31-terraform-apply-ecs.png)** · **[Watch walkthrough (2:11)](https://youtu.be/qpIZlJkWmos)**

> **CI/CD scope:** The ECS image workflow **builds and pushes images to ECR**. Image publication alone is not an automated ECS service rollout; that additional release step is identified in the detailed project README.

### 2. Amazon EKS — Kubernetes, GitOps & Observability

**AWS EKS · Terraform · Kubernetes · Helm · NGINX Ingress · Argo CD · Prometheus · Grafana · GitHub Actions**

I provisioned an **Amazon EKS Kubernetes environment** using Terraform, configured worker-node networking and deployed **IT-Tools with two replicas**. I added **NGINX Ingress, an AWS Network Load Balancer, cert-manager, ExternalDNS and Cloudflare** to route HTTPS traffic to the application.

I integrated **Argo CD for Git-based reconciliation**, deployed **Prometheus and Grafana** for resource visibility, and automated infrastructure and application tasks through GitHub Actions with AWS OIDC authentication.

**Engineering highlights**

- Configured an EKS managed node group with a **desired size of four workers** spanning two Availability Zones.
- Used Kubernetes **Deployments, Services, Ingress, probes and resource controls**.
- Demonstrated **Argo CD application health and synchronisation** alongside working application access over HTTPS.
- Configured Prometheus/Grafana monitoring and investigated monitoring Pods and persistent volume claims stuck in `Pending`.
- Resolved issues involving **EBS CSI storage, IAM permissions, pod capacity, GitHub OIDC and EKS access configuration**.

**Deployment proof — Argo CD application reconciliation**

![Amazon EKS Argo CD application synced and healthy](https://raw.githubusercontent.com/ismaaeelahmed11/eks-project/main/screenshots/24-argocd-synced.png)

**[View EKS source, architecture and full README](https://github.com/ismaaeelahmed11/eks-project)** · **[Architecture diagram](https://github.com/ismaaeelahmed11/eks-project/blob/main/screenshots/31-architecture-drawio.png)** · **[HTTPS deployment](https://github.com/ismaaeelahmed11/eks-project/blob/main/screenshots/17-it-tools-live-https.png)** · **[Grafana dashboard](https://github.com/ismaaeelahmed11/eks-project/blob/main/screenshots/27-grafana-dashboard.png)** · **[Watch walkthrough (2:29)](https://youtu.be/RDmnaTi2auE)**

> **Engineering scope:** The project demonstrates production-grade practices, not a production-certified service. The security scans report findings without blocking the pipeline, and aligning direct GitHub Actions deployment with Argo CD as a single GitOps release owner is a documented improvement.

### 3. Self-Managed Kubernetes — kubeadm & Linux

**Ubuntu · VirtualBox · kubeadm · containerd · Calico · kubectl · Kubernetes Services · Cluster Operations**

After completing EKS, I independently built a **two-node Kubernetes cluster** on Ubuntu virtual machines to work directly with the components that a managed Kubernetes service normally abstracts.

I configured **NAT and host-only networking**, set static addresses, installed **containerd**, bootstrapped Kubernetes using **kubeadm**, installed **Calico** and joined a worker node. I deployed NGINX with **ClusterIP and NodePort Services**, health probes, resource limits and a controlled rolling-update strategy.

**Engineering highlights**

- Verified the **control plane and worker node in the `Ready` state**.
- Scaled the NGINX Deployment to **four replicas** on the worker node.
- Deleted a Pod and observed Kubernetes **replace it automatically**.
- Tested **rolling updates, rollout status, rollback and application access after changes**.
- Investigated **VirtualBox CPU/virtualisation problems**, Kubernetes bootstrap and administrative access/RBAC.

**Deployment proof — two-node Kubernetes cluster Ready**

![Self-managed kubeadm Kubernetes control plane and worker node Ready](https://raw.githubusercontent.com/ismaaeelahmed11/kubeadm-kubernetes-lab/main/screenshots/49-two-node-kubernetes-cluster-ready.png)

**[View kubeadm source, manifests and full README](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)** · **[Architecture diagram](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab/blob/main/screenshots/59-kubeadm-kubernetes-architecture.png)** · **[Four-replica evidence](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab/blob/main/screenshots/55-nginx-horizontal-scaling-four-replicas.png)** · **[Self-healing evidence](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab/blob/main/screenshots/54-kubernetes-self-healing-replacement-pod.png)** · **[Watch walkthrough (2:00)](https://youtu.be/a9hATioCGcs)**

> **Operational scope:** Pod-level self-healing, scaling and rollback were tested. The lab has one control plane and one worker; I have **not** claimed worker-node high availability or a completed kubeadm control-plane/kubelet/kubectl version upgrade.

---

## Technical Skills — Linked to Implementation

The table below connects the tools and topics in my portfolio to **specific code, configuration or captured results**.

| Area | Hands-on implementation | Evidence |
| --- | --- | --- |
| **Linux / Ubuntu** | Command-line administration, permissions, processes, SSH, text processing and Ubuntu VM configuration | [Linux labs](linux/) · [kubeadm lab](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab) |
| **Bash** | Interactive calculator, file automation, permissions checks and timestamped backups | [Bash scripts](bash-scripting/) |
| **Git / GitHub** | Branches, merges, conflict resolution, rebase, stash, revert and pre-commit workflows | [Git labs](https://github.com/ismaaeelahmed11/git-labs) |
| **Networking** | DNS, SSH, HTTP/TLS, security groups, routing, VPC subnets, ALB and Kubernetes Services | [Networking lab](networking/) · [ECS networking](ecs-project/terraform/modules/) |
| **Docker** | Dockerfiles, multi-stage builds, Docker Compose, Flask/Redis and container registries | [Docker labs](docker/) · [ECS Dockerfile](ecs-project/Dockerfile) |
| **AWS** | EC2, VPC, IAM, security groups, ECR, ECS, EKS, ALB, ACM and CloudWatch | [AWS labs](aws/) · [ECS](ecs-project/) · [EKS](https://github.com/ismaaeelahmed11/eks-project) |
| **Terraform** | AWS provisioning, modular IaC, S3 remote state, locking, plans and teardown | [Terraform labs](terraform/) · [ECS Terraform](ecs-project/terraform/) |
| **CI/CD** | Automated Python tests, Docker image publishing, Terraform plans/applies and AWS OIDC | [CI/CD labs](cicd/) · [Actions workflows](.github/workflows/) |
| **Kubernetes / Helm** | Deployments, Services, probes, pod networking, kubeadm bootstrap and Helm-based add-ons | [K8s exercises](k8s/exercises/) · [EKS](https://github.com/ismaaeelahmed11/eks-project) · [kubeadm](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab) |
| **GitOps / Observability** | Argo CD reconciliation, Prometheus metrics collection and Grafana dashboards | [EKS project](https://github.com/ismaaeelahmed11/eks-project) · [Argo CD proof](https://github.com/ismaaeelahmed11/eks-project/blob/main/screenshots/29-argocd-ui.png) |
| **Security practices** | Short-lived OIDC credentials, IAM roles, HTTPS, non-root containers and Checkov/Trivy scanning | [ECS IAM/OIDC](ecs-project/terraform/modules/) · [EKS workflows](https://github.com/ismaaeelahmed11/eks-project/tree/main/.github/workflows) |

---

## Technical Foundations — Nine Hands-On Modules

These labs explain **how I developed the skills used in the three larger projects**. Their individual directories contain exercises, code, notes and, where available, screenshots. The flagship projects above are the stronger evidence of end-to-end integration.

### 01 · Linux & System Administration

**Ubuntu · Shell · SSH · Permissions · Processes · Text Processing**

- Worked with navigation, files, permissions, ownership and command-line process management.
- Used `grep`, `sed`, `awk`, regular expressions, pipes and redirection to inspect and transform text.
- Practised SSH access, file searches, archive handling and command-line troubleshooting.
- Documented **OverTheWire Bandit levels 0–20** with notes and supporting screenshots.

**[Explore Linux labs, notes and Bandit evidence](linux/)**

### 02 · Bash Scripting & Automation

**Bash · Variables · Conditionals · Loops · Input · Exit Codes**

- Created an **arithmetic calculator** with division-by-zero handling.
- Automated directory/file creation and timestamped file operations.
- Wrote a **file permission checker** for readability, writability and executability.
- Built a **timestamped text-file backup script** and debugged shell quoting/globbing behaviour.

**[Explore Bash source and exercises](bash-scripting/)**

### 03 · Git & Version Control

**Git · GitHub · Branching · Merging · Rebase · Recovery**

- Practised `clone`, `add`, `commit`, `push`, `pull`, branching and merges.
- Worked with merge conflicts, stashing, reset/revert, rebase, cherry-pick and reflog.
- Used `.gitignore`, SSH authentication and pre-commit hooks.
- Applied Git version control to Terraform modules, Kubernetes YAML and workflow configuration.

**[Explore the separate Git labs repository](https://github.com/ismaaeelahmed11/git-labs)**

### 04 · Networking & Connectivity

**TCP/IP · DNS · SSH · Routing · Security Groups · Cloudflare**

- Deployed **NGINX on an Ubuntu EC2 instance** and exposed it using a Cloudflare-managed domain.
- Configured an EC2 security group for HTTP and SSH connectivity.
- Diagnosed an HTTP connection timeout caused by a missing inbound port-80 rule.
- Used DNS checks with `dig` and `nslookup` while investigating name-resolution behaviour.

**[Explore networking labs and troubleshooting](networking/)**

### 05 · Docker & Containerisation

**Docker · Docker Compose · Flask · Redis · Registries**

- Built and ran images from Dockerfiles and inspected container behaviour and logs.
- Deployed a **Flask + Redis** application with Docker Compose and container-to-container communication.
- Investigated multi-stage build dependencies, container networking and port conflicts.
- Practised image tagging and pushing to Docker Hub/ECR before applying the same skills to ECS.

**[Explore Docker labs and Compose project](docker/)**

### 06 · AWS Infrastructure

**EC2 · VPC · Subnets · Internet Gateways · ALB · IAM**

- Provisioned AWS networking with subnets, route tables, gateways and security groups.
- Worked with **EC2 user data** to configure instances on launch.
- Configured Application Load Balancers, target groups and health checks.
- Applied these fundamentals in larger ECS and EKS infrastructure deployments.

**[Explore AWS labs](aws/)**

### 07 · Terraform & Infrastructure as Code

**Terraform · HCL · AWS · Variables · Outputs · State**

- Provisioned a **WordPress EC2 environment** using Terraform and cloud-init.
- Practised `terraform init`, `plan`, `apply` and `destroy` alongside variable and output management.
- Progressed from individual resources to modular infrastructure and remote state.
- Applied these skills in the ECS eight-module infrastructure and EKS platform deployment.

**[Explore Terraform labs](terraform/)** · **[View the larger ECS Terraform implementation](ecs-project/terraform/)**

### 08 · CI/CD with GitHub Actions

**GitHub Actions · Pytest · Docker Publishing · YAML · Triggers**

- Created a **CI workflow** to run Python/Flask tests on relevant pushes and pull requests.
- Created an image **build-and-push workflow** targeting Docker Hub.
- Practised workflow triggers, repository secrets, YAML structure and debugging failed runs.
- Extended the same concepts into AWS OIDC-authenticated infrastructure and application workflows.

**[Explore CI/CD exercises](cicd/)** · **[View repository-level workflows](.github/workflows/)**

### 09 · Kubernetes & Workload Management

**kubectl · Pods · Deployments · Services · ConfigMaps · Secrets**

- Practised Kubernetes objects, application deployments and workload inspection.
- Worked with Services, storage concepts and resource configuration in **Kind and Killercoda** environments.
- Built on these exercises by deploying a managed platform on EKS.
- Independently configured a **kubeadm cluster** and tested scaling, self-healing, updates and rollback.

**[Explore Kubernetes exercises](k8s/exercises/)** · **[View kubeadm operational tests](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)**

---

## Engineering Problem-Solving — Real Issues Resolved

I retain failed states and troubleshooting notes alongside successful screenshots because knowing **why a system failed** matters as much as getting a deployment working.

| Problem | Investigation / correction | What it demonstrates |
| --- | --- | --- |
| **ECS task exited during startup** | Investigated non-root execution and port binding; aligned the Go listener, task, target group and security group on port `8080` | Container runtime and application networking |
| **CloudWatch logging permission failure** | Checked the ECS execution role and added the required `logs:CreateLogGroup` permission | AWS IAM and operational diagnostics |
| **Terraform S3 lockfile failed in CI** | Compared tool versions; updated GitHub Actions Terraform from `1.9.0` to `1.11.0` | Tool compatibility and IaC pipelines |
| **GitHub Actions workflows did not trigger** | Found workflow files in a project subdirectory; moved them to repository-root `.github/workflows/` | CI/CD troubleshooting and repository structure |
| **EKS monitoring Pods / PVCs Pending** | Investigated capacity, EBS CSI storage provisioning and AWS IAM; configured storage integration and increased node-group capacity | Kubernetes scheduling, CSI storage and IAM |
| **EKS OIDC / access conflicts** | Checked GitHub OIDC trust claims and conflicting EKS cluster access settings | Authentication, authorisation and Terraform configuration |
| **kubeadm bootstrap / VM instability** | Investigated VirtualBox CPU acceleration, Kubernetes component health and administrative API/RBAC access | Linux infrastructure and Kubernetes cluster troubleshooting |

**Detailed investigations and supporting evidence:** [ECS troubleshooting](ecs-project/#troubleshooting--root-cause-analysis) · [EKS troubleshooting](https://github.com/ismaaeelahmed11/eks-project#troubleshooting-and-root-cause-analysis) · [kubeadm troubleshooting](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab#troubleshooting--root-cause-investigation)

---

## Repository Guide

```text
 devops-learning/
 ├── .github/workflows/      # GitHub Actions CI/CD and AWS workflows
 ├── aws/                    # AWS networking, compute and infrastructure exercises
 ├── bash-scripting/         # Bash automation scripts
 ├── cicd/                   # CI testing and image-publishing exercises
 ├── docker/                 # Dockerfiles and Compose-based applications
 ├── ecs-project/            # End-to-end ECS Fargate + Terraform project
 ├── k8s/exercises/          # Kubernetes workload exercises
 ├── linux/                  # Linux notes and Bandit evidence
 ├── networking/             # DNS, EC2, SSH and HTTP connectivity labs
 ├── terraform/              # Terraform resource and cloud-init exercises
 └── README.md               # This portfolio overview
```

The EKS, kubeadm and Git-focused work also has its own repository:

- **[eks-project](https://github.com/ismaaeelahmed11/eks-project)** — managed Kubernetes platform, IaC, GitOps, monitoring and troubleshooting.
- **[kubeadm-kubernetes-lab](https://github.com/ismaaeelahmed11/kubeadm-kubernetes-lab)** — Linux VMs, Kubernetes cluster administration and operational tests.
- **[git-labs](https://github.com/ismaaeelahmed11/git-labs)** — Git commands, workflows, history management and recovery exercises.

---

## Engineering Approach & Project Context

I use the same approach across these labs and projects:

1. **Understand the system:** Identify the purpose of each component and how data, traffic and permissions flow through it.
2. **Build and verify:** Run local checks, inspect service state and test the application or infrastructure outcome.
3. **Automate where practical:** Move repeatable work into Bash, Terraform, declarative Kubernetes YAML or GitHub Actions.
4. **Investigate failures:** Follow errors through logs, networking, IAM, scheduling, storage or tool versions rather than repeatedly retrying commands.
5. **Document and improve:** Preserve source configuration, screenshots, architecture diagrams, recovery decisions and limitations.

I completed the **CoderCo DevOps Engineering programme (January–October 2026)**. My AWS ECS and EKS projects were completed as part of that training; I subsequently built the self-managed kubeadm cluster independently to deepen my Linux and Kubernetes administration skills.

The AWS projects used **real cloud infrastructure** and incorporated practices common to professional environments, including IaC, OIDC, HTTPS, CI/CD, health checking and monitoring. They were **portfolio deployments, not commercial production services**. Where a workflow is incomplete or security/reliability controls were not enforced or tested, I document that explicitly in the relevant technical README.

**Currently pursuing Junior DevOps, Cloud Engineering, Platform Engineering and Infrastructure roles in the UK.** This portfolio is intended to provide concrete evidence of the technologies I can work with and the engineering decisions I can explain.

---

## Contact & Technical Walkthroughs

**Ismaaeel Ahmed — DevOps & Cloud Engineering**

[GitHub](https://github.com/ismaaeelahmed11) · [LinkedIn](https://www.linkedin.com/in/ismaaeelahmed) · [Email](mailto:ismaaeelahmed11@gmail.com)

**Video walkthroughs:** [AWS ECS (2:11)](https://youtu.be/qpIZlJkWmos) · [AWS EKS (2:29)](https://youtu.be/RDmnaTi2auE) · [Self-managed kubeadm (2:00)](https://youtu.be/a9hATioCGcs)
