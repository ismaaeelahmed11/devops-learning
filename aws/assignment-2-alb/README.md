# Assignment 2 — Application Load Balancer

Deployed two EC2 instances behind an Application Load Balancer. The ALB distributes traffic across both instances. EC2s are not directly accessible from the internet — all traffic goes through the ALB.

---

## Architecture

- ALB (internet-facing, port 80)
- Two EC2 instances in `assignment-vpc` (eu-west-2a)
- Apache web server on each instance via user data
- Target group with health checks on `/`
- Security groups: ALB accepts from anywhere, EC2 only accepts from ALB SG

## How it works

- Browser → ALB DNS → ALB (port 80) → Target Group → EC2-A or EC2-B
- Health checks verify each instance is healthy before routing traffic
- Refreshing alternates between "Hello from Server A" and "Hello from Server B"

## Security Groups

| SG | Inbound |
|----|---------|
| alb-sg | HTTP (80) from 0.0.0.0/0 |
| alb-ec2-sg | HTTP (80) from alb-sg only |

## Testing

- Visited ALB DNS — "Hello from Server A"
- Refreshed — "Hello from Server B"
- Both target group instances showed healthy

## Challenge

Server B's user data script didn't execute. Apache wasn't installed. Had to SSH in and manually install httpd and create the index.html file.

**Lesson:** Always verify user data ran successfully. Check `curl localhost` after launch.

## What I Learned

- ALB distributes traffic across multiple instances
- Target groups + health checks ensure traffic only goes to healthy instances
- Security groups can reference other security groups — EC2 only accepts ALB traffic
- User data scripts are powerful but not infallible — always verify
