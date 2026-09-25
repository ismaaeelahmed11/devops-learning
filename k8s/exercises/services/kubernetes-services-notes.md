# Services

Pods have random IPs that change when they restart. Services give a stable name and IP in front of pods, so other things can reach them reliably.

---

## Service Types

### ClusterIP (default)
- Internal only
- Reachable from inside the cluster
- Used for pod-to-pod communication

### NodePort
- Exposes the service on every node's IP at a specific port (30000-32767)
- Reachable from outside via `node-IP:nodePort`
- Used for testing/dev

### LoadBalancer
- Cloud provider gives an external IP
- Reachable from the internet
- Used in production on AWS/GCP/Azure

### Headless Service
- No ClusterIP
- Returns pod IPs directly via DNS
- Used for stateful apps (databases, Kafka)

### ExternalName
- Points to an external DNS name
- Lets pods reach outside resources using a K8s service name

---

## How Services Find Pods

Uses **labels and selectors**.

```yaml
# Service
selector:
  app: nginx
```

```yaml
# Pod
labels:
  app: nginx
```

Match → service routes traffic to that pod.

Pods come and go. Service stays the same. New pods with the same label get picked up automatically.

---

## Ports Explained

| Port | Where | Purpose |
|------|-------|---------|
| containerPort | Container | What the app listens on |
| targetPort | Service forwards to | The pod's port |
| port | Service | What other things use to reach the service |
| nodePort | Node | Exposed port on the node (NodePort services only) |

For simple setups, all three are 80.

---

## Example: ClusterIP + Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
```

---

## Pod Networking Model (Flat)

Every pod gets its own IP. Any pod can reach any other pod directly — no NAT, no port mapping.

- Same node or different node — doesn't matter
- Handled by a CNI plugin (Calico, Cilium, Flannel)
- Flat network = simple, fast

---

## Testing

Since ClusterIP is internal only, test from inside the cluster using a debug pod:

```
kubectl run tmp-shell --rm -i --tty --image=nicolaka/netshoot
```

Inside the pod:

```
nslookup nginx-svc
curl nginx-svc
```

That proves the service is reachable by name.

To access from your laptop (temporary tunnel):

```
kubectl port-forward svc/nginx-svc 8080:80
```

Then browse `http://localhost:8080`.

---

## Key Commands

```
kubectl get svc                       # list services
kubectl describe svc nginx-svc        # full details + endpoints
kubectl get endpoints nginx-svc       # which pods are behind it
kubectl port-forward svc/nginx-svc 8080:80   # temporary tunnel
```

---

## Service Mesh (Overview)

A service mesh handles traffic between services centrally. Instead of each app handling retries, encryption, and observability, a sidecar proxy does it.

- Tools: Istio, Linkerd
- Adds mTLS, retries, metrics, tracing
- Advanced — not needed for basics

---

## What I Learned

- Services give pods a stable address
- ClusterIP = internal, NodePort = external on node, LoadBalancer = cloud
- Headless services skip ClusterIP and return pod IPs
- Services use selectors to match pod labels
- Pod IPs change, service IPs don't
- You never hardcode pod IPs — use the service name
- `kubectl port-forward` is a temporary tunnel for testing ClusterIP
- The pod network is flat — every pod can reach every pod
- Service meshes centralise traffic control