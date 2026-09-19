# Pods

A pod is the smallest deployable unit in Kubernetes. It wraps one or more containers that share the same network and storage.

## Two Ways to Create a Pod

### 1. Declarative (YAML)

File: `nginx-pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
        - containerPort: 80
```

Apply it:

```bash
kubectl apply -f nginx-pod.yaml
```

### 2. Imperative (command line)

```bash
kubectl run nginx-pod --image=nginx --port=80
```

## What Each Field Means

| Field | Meaning |
|-------|---------|
| apiVersion: v1 | API version for Pod |
| kind: Pod | The object type |
| metadata.name | Pod's name |
| metadata.labels | Key-value tags for grouping |
| spec.containers | List of containers inside the pod |
| image | Docker image to run |
| containerPort | Port the container listens on |

## Key Commands

```bash
kubectl apply -f nginx-pod.yaml     # create from YAML
kubectl get pods                    # list pods
kubectl describe pod nginx-pod      # full details
kubectl logs nginx-pod              # view container logs
kubectl exec -it nginx-pod -- bash  # shell into the pod
kubectl delete pod nginx-pod        # delete it
```

## What I Learned

- Pods are the smallest unit — one or more containers
- Containers in the same pod share networking and storage
- Pods are ephemeral — if one dies, it's gone (unless managed by a ReplicaSet/Deployment)
- For production, you almost never create pods directly — use Deployments