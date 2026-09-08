# Terraform Assignment 2 — EC2 with Cloud-Init

Used Terraform and cloud-init to deploy an EC2 instance that automatically installs and configures NGINX on boot. No manual SSH or setup required.

---

## What I Built

- EC2 instance running Ubuntu 26.04
- Security group allowing SSH (22) and HTTP (80)
- cloud-init YAML passed via Terraform `user_data`
- NGINX installed and running automatically
- Browser shows "Hello from Cloud-Init"

## Files

| File | Purpose |
|------|---------|
| `main.tf` | AWS provider, security group, EC2 instance |
| `variables.tf` | AMI and instance type |
| `outputs.tf` | Public IP and URL |
| `cloud-init.yaml` | Boot automation — installs NGINX, creates test page |
| `.gitignore` | Keeps state files out of Git |

## How It Works

- Terraform reads `cloud-init.yaml`
- Passes it as `user_data` to the EC2 instance
- cloud-init runs on first boot
- Installs NGINX, starts it, creates `index.html`
- Instance comes online fully configured

## What I Learnt

- cloud-init is the standard for bootstrapping Linux instances
- `#cloud-config` format is declarative — packages, commands, files
- Terraform's `file()` function reads local files and passes them as user_data
- No manual steps needed — the instance configures itself

## Commands

terraform init
terraform plan
terraform apply
terraform output url
terraform destroy