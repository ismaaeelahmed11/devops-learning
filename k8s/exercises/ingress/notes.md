# Ingress, Cert-Manager & ExternalDNS

Ingress exposes HTTP/HTTPS routes from outside the cluster to services inside. Cert-Manager automates SSL certificates. ExternalDNS automates DNS records.

---

## Ingress

### What It Is
- Routes HTTP/HTTPS traffic from outside into the cluster
- Routes by domain and/or path
- Needs an Ingress Controller (NGINX, Traefik, ALB)
- One Ingress can route to many services

### Why Not NodePort/LoadBalancer
- NodePort: one port per service, no domain routing
- LoadBalancer: one cloud LB per service — expensive
- Ingress: one entry point, routes to many services

---

## Cert-Manager

### What It Is
- Automates SSL/TLS certificate issuance and renewal
- Works with Let's Encrypt, AWS ACM, and other CAs
- Watches Ingress resources and issues certs automatically

### Key Resources

| Resource | What It Does |
|----------|-------------|
| Issuer | Namespace-scoped certificate issuer |
| ClusterIssuer | Cluster-wide certificate issuer |
| Certificate | Request for an SSL certificate |

### The Flow
1. Create a ClusterIssuer (e.g. Let's Encrypt)
2. Add an annotation to your Ingress
3. Cert-Manager requests a cert
4. Cert stored in a Secret
5. Ingress uses it for HTTPS

### Example Certificate

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: app-tls
spec:
  secretName: app-tls-secret
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  dnsNames:
    - app.example.com
```

---

## ExternalDNS

### What It Is
- Automates DNS records in Cloudflare, Route53, etc.
- Watches Ingress/Service resources
- Creates/updates A records automatically

### Why It Matters
- Without it: manually create DNS records for every service
- With it: Kubernetes updates DNS whenever Ingress changes

### The Flow
1. Deploy ExternalDNS with access to your DNS provider
2. Create an Ingress with a host (app.example.com)
3. ExternalDNS creates the A record
4. DNS points to your cluster's load balancer

---

## How It All Fits Together

```
User → Domain (DNS via ExternalDNS) → Load Balancer → Ingress → Service → Pod
```

With cert-manager handling HTTPS along the way.

---

## One-line Summary

| Tool | Job |
|------|-----|
| Ingress | Route HTTP/HTTPS traffic |
| Cert-Manager | Auto SSL certificates |
| ExternalDNS | Auto DNS records |

---

## What I Learned

- Ingress = one entry point, routes to many services
- Cert-Manager = no more manual SSL renewals
- ExternalDNS = no more manual DNS edits
- Together they automate the entire external access layer
- These are used in production EKS clusters