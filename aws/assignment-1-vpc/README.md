# Assignment 1 — VPC & Networking

Built a custom VPC with public and private subnets, internet gateway, NAT gateway, and route tables. Deployed EC2 instances in each subnet and verified connectivity.

---

## Architecture

- VPC: `10.0.0.0/16`
- Public Subnet: `10.0.1.0/24` (eu-west-2a)
- Private Subnet: `10.0.2.0/24` (eu-west-2b)
- Internet Gateway for public internet access
- NAT Gateway in public subnet for private subnet outbound traffic
- Public EC2 with public IP (bastion)
- Private EC2 with no public IP (only accessible from public EC2)

## Route Tables

| Route Table | Associated Subnet | Route |
|-------------|-------------------|-------|
| public-rt | public-subnet | `0.0.0.0/0` → Internet Gateway |
| private-rt | private-subnet | `0.0.0.0/0` → NAT Gateway |

## Security Groups

| SG | Inbound |
|----|---------|
| public-instance-sg | SSH (22) + HTTP (80) from My IP |
| private-instance-sg | SSH (22) from public-instance-sg |

## Testing

- Successfully SSH'd from local machine → public EC2 → private EC2
- Private EC2 pinged google.com successfully — NAT Gateway working

## What I Learned

- VPC is the foundation of AWS networking
- Public vs private subnets — one faces the internet, one is hidden
- Route tables control traffic direction
- NAT Gateway gives private instances internet access without exposing them
- Security groups can reference other security groups, not just IPs
