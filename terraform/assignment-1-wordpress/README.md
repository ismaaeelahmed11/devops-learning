# Terraform Assignment 1 — Deploy WordPress

Used Terraform to deploy a full WordPress stack on AWS: EC2 instance, security groups, user data installation, and a public endpoint.

---

## What I Built

- EC2 instance running Amazon Linux 2023
- Security group allowing SSH (22) and HTTP (80)
- User data script installing Apache, PHP, and WordPress on boot
- Public IP serving the WordPress setup page

## Files

| File | Purpose |
|------|---------|
| `main.tf` | AWS provider, security group, EC2 resource |
| `variables.tf` | AMI ID and instance type |
| `outputs.tf` | Public IP and WordPress URL |
| `user-data.sh` | Boot script — installs Apache, PHP, WordPress |

## Challenges & Fixes

### Challenge 1: Browser refused to connect
Instance launched but WordPress didn't load. SSH'd in and found Apache wasn't installed — the user data script didn't run properly.

**Fix:** Manually installed Apache, PHP, and WordPress via SSH. Deleted the default `index.html`. Refreshed and WordPress loaded.

### Challenge 2: GitHub rejected push — file too large
Accidentally pushed the `.terraform/` folder containing the AWS provider binary (838MB). GitHub's limit is 100MB.

**Fix:** Added `.gitignore` for `.terraform/` and state files. Used `git filter-repo` to clean the file from Git history. Force pushed the clean version.

## What I Learnt

- Terraform deploys infrastructure end-to-end — network, compute, security
- User data scripts don't always run perfectly — always verify
- Never commit `.terraform/` or state files to Git
- `.gitignore` is essential for Terraform projects
- `git filter-repo` cleans large files from history

## Key Commands

terraform init       # download providers
terraform plan       # preview changes
terraform apply      # deploy
terraform destroy    # tear down
terraform output     # get public IP and URL