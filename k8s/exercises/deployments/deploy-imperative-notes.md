# Imperative Deployment

Created a deployment from the command line instead of writing a YAML file.

## Command

kubectl create deploy nginx-deployment --image=nginx --replicas=2

## Breakdown

- kubectl create deploy  → create a Deployment object
- nginx-deployment       → name of the deployment
- --image=nginx          → which Docker image to use
- --replicas=2           → how many pod copies to run

## What Happened

- Created a deployment called nginx-deployment
- Deployment created a ReplicaSet
- ReplicaSet created 2 pods running nginx

## Imperative vs Declarative

| Imperative | Declarative |
|-----------|-------------|
| Typed in the terminal | Written in a YAML file |
| Fast, one-off | Reusable, version-controlled |
| Not tracked in Git | Lives in Git, applied via kubectl apply |

For production and GitOps, declarative is the standard.