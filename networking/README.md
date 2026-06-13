# Networking Module

Completed the networking module — covering how data moves across networks and applying it by deploying a live web server on my own domain.

---

## What I Built

Deployed a live NGINX web server on AWS and made it accessible via my own domain.

### Steps:
1. Launched an EC2 instance (t3.micro) running Ubuntu on AWS
2. Configured a security group — opened port 80 (HTTP) and port 22 (SSH)
3. Connected via SSH and installed NGINX
4. Bought a domain through Cloudflare
5. Created an A record pointing the domain to my EC2 public IP
6. Opened the browser and saw the NGINX welcome page on my own domain

### How it works:

Browser → Domain (DNS A record) → EC2 Public IP → Security Group (port 80) → NGINX → Welcome Page

---

## What I Learnt

### IP Addressing & DNS
- Every server has a public IP that uniquely identifies it on the internet
- DNS translates domain names into IP addresses so browsers can find servers
- A records map a domain directly to an IPv4 address
- DNS propagation isn't instant — changes can take a few minutes

### Firewalls & Security Groups
- Security groups act as virtual firewalls for cloud instances
- Inbound rules control what traffic is allowed in
- You must explicitly open ports — by default everything is blocked

### Protocols & Ports
- HTTP uses port 80, SSH uses port 22
- If the wrong port is blocked, the connection fails
- Understanding ports is essential for debugging

### The OSI Model in Practice
- Layer 3 (Network) — IP addressing and routing
- Layer 4 (Transport) — ports and TCP connections
- Layer 7 (Application) — HTTP and NGINX serving content
- A timeout at the browser could be DNS, a firewall, or the server itself — the layers help narrow it down

---

## Challenges I Faced

### Challenge 1: Connection Timed Out
After launching EC2 and installing NGINX, I pasted the public IP into my browser and nothing loaded — just a timeout.

**Cause:** I hadn't opened port 80 (HTTP) in the security group. By default, AWS only opens port 22 (SSH).

**Fix:** Edited the inbound rules to allow HTTP traffic from anywhere (0.0.0.0/0). Refreshed the browser and NGINX loaded immediately.

**Lesson:** Firewalls block everything by default. If something doesn't connect, check the security group rules first — it's almost always the culprit.

---

### Challenge 2: DNS Propagation Delay
After creating the A record in Cloudflare, my domain still wasn't loading. Kept refreshing, nothing.

**Cause:** DNS changes take time to propagate across the internet. The TTL (time to live) on the record hadn't expired yet.

**Fix:** Waited 5-10 minutes and tried again. Used `dig` and `nslookup` to check if the record had propagated. Once it resolved, the domain loaded perfectly.

**Lesson:** DNS is not instant. Use `dig <domain.com>` to check the current state of a DNS record. If it returns the correct IP, the issue is elsewhere. If it doesn't, just wait.

---

## Commands I Used

# SSH into the EC2 instance
ssh -i ~/.ssh/nginx-key.pem ubuntu@<PUBLIC_IP>

# Update and install NGINX
sudo apt update
sudo apt install nginx -y

# Check it's running
sudo systemctl status nginx

# DNS troubleshooting
dig <domain.com>
nslookup <domain.com>
ping <domain.com>

# Test HTTP response
curl -I <domain.com>

---

## Screenshots
- EC2 instance running in AWS dashboard
- NGINX welcome page loading via public IP
- NGINX welcome page loading via custom domain
