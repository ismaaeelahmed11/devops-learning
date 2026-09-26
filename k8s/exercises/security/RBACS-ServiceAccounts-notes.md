# Kubernetes Security — RBAC & Service Accounts

RBAC controls **who can do what** in Kubernetes. Service Accounts give pods an identity to authenticate with the API server.

---

## RBAC (Role-Based Access Control)

### What It Is
- Authorisation system for Kubernetes
- Controls who can perform which actions on which resources
- Based on roles and bindings

### Key Resources

| Resource | Scope | What It Does |
|----------|-------|-------------|
| Role | Namespace | Defines permissions within a namespace |
| ClusterRole | Cluster | Defines permissions cluster-wide |
| RoleBinding | Namespace | Binds a Role to a user/group/SA |
| ClusterRoleBinding | Cluster | Binds a ClusterRole cluster-wide |

### RBAC Evaluation Flow

1. User or Service Account makes a request to the API server
2. API server checks authentication (who are you?)
3. Then checks authorisation via RBAC (what can you do?)
4. Looks at all RoleBindings and ClusterRoleBindings
5. If any grant the required permission → allow
6. Otherwise → deny

### RBAC Evaluation Example (simple)

```
User: ismaaeel
Request: delete pods in namespace "dev"

1. Authenticated? Yes
2. Check RoleBindings in "dev" namespace
3. Found: RoleBinding "dev-deleter" → Role "pod-deleter"
4. Role "pod-deleter" allows: delete pods
5. Permission granted → action allowed
```

---

## Service Accounts

### What They Are
- Identity for pods and processes
- Used to authenticate with the API server
- Every pod has one (default if not specified)

### How They Work

- Each Service Account has a token
- Token is mounted into the pod at `/var/run/secrets/kubernetes.io/serviceaccount/`
- Pod uses this token to authenticate with the API server
- API server checks RBAC to decide what the pod can do

### The Flow

1. Pod created → assigned a Service Account (default or custom)
2. Token mounted into the pod filesystem
3. Pod makes API call → sends token in Authorization header
4. API server validates the token
5. RBAC rules determine what the pod is allowed to do

### Example: Using a Service Account in a Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: my-service-account
  containers:
    - name: app
      image: nginx
```

Without `serviceAccountName`, the pod uses `default`.

---

## RBAC vs Service Accounts

| Concept | What It Does |
|---------|-------------|
| Service Account | Identity — "who is this pod?" |
| RBAC | Permissions — "what is this identity allowed to do?" |

They work together:
- Service Account = authentication
- RBAC = authorisation

---

## What I Learned

- RBAC controls who can do what in Kubernetes
- Roles are namespace-scoped, ClusterRoles are cluster-wide
- RoleBindings link identities to Roles
- Every pod has a Service Account
- Service Account tokens are mounted into pods
- The API server authenticates (SA) then authorises (RBAC)
- Always grant least privilege — don't use cluster-admin for pods