# ReplicaSets vs Deployments

## What I Did

Created a deployment with 5 replicas, then deleted one pod to test self-healing.

### Commands Used

# Create deployment with 5 replicas
kubectl create deploy nginx-deployment --image=nginx --replicas=5

# Check deployments
kubectl get deploy

# Check pods
kubectl get pods

# Check replicasets
kubectl get replicasets

# Delete a pod to test self-healing
kubectl delete pod nginx-deployment-7d6869886d-8l5ph

# Watch it get replaced
kubectl get pods

## What I Learned

### Deployment
- Manages ReplicaSets
- Handles rolling updates and rollbacks
- Declarative — you say "I want 5 pods", Kubernetes makes it happen

### ReplicaSet
- Ensures a specific number of pods are always running
- If a pod dies, it creates a new one
- Created automatically by a deployment

### Self-Healing in Action
- I deleted a pod → ReplicaSet noticed → created a new one immediately
- Still had 5 replicas running
- Zero downtime, zero manual intervention

## Key Difference

| Deployment | ReplicaSet |
|-----------|-----------|
| Higher level | Lower level |
| Manages ReplicaSets | Manages Pods directly |
| Supports rolling updates | Doesn't handle updates |
| What you should use | Rarely used directly |

## Real-world Use

In production, you always create Deployments, not ReplicaSets. Deployments give you:
- Rolling updates (no downtime)
- Rollbacks if something breaks
- Version history
- Scaling

ReplicaSets are managed for you — you never touch them directly.

## Command Reference

kubectl get deploy              # list deployments
kubectl get rs                  # list replicasets
kubectl get pods                # list pods
kubectl delete pod <name>       # delete a pod (watch it self-heal)
kubectl scale deploy <name> --replicas=N   # scale a deployment
