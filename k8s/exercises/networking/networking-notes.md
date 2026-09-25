# Kubernetes Networking

Every pod gets its own IP. Pods can talk to each other directly — no NAT, no port mapping.

---

## Pod to Pod Communication

### What I Did

1. Ran two pods: `nginx` and `apache`
2. Got their IPs with `kubectl get pods -o wide`
3. SSH'd into the `nginx` pod
4. Curled the `apache` pod's IP directly
5. Got the Apache welcome page back

### Commands

```
kubectl run nginx --image=nginx
kubectl run apache --image=httpd
kubectl get pods -o wide
kubectl exec -it nginx -- sh
curl <apache-pod-ip>
```

### What It Proves

- Every pod has its own IP in the cluster
- Pods can reach each other directly
- No NAT, no port forwarding needed
- This is called the **flat network model**

### Why It Works

A CNI (Container Network Interface) plugin handles pod networking:
- Assigns IPs to every pod
- Routes traffic between pods (same node or different nodes)
- Common CNIs: Calico, Cilium, Flannel, Weave

---

## Key Points

- Pod IPs: change when pods restart
- Flat network = any pod can reach any pod
- This is the foundation for services and DNS

---

## Key Commands

```
kubectl run <name> --image=<image>        # create a pod
kubectl get pods -o wide                  # see pod IPs and node
kubectl exec -it <pod> -- sh              # shell into a pod
curl <pod-ip>                             # test pod-to-pod
```

---

## What I Learned

- Every pod has a unique IP
- Pods talk to each other directly — no NAT
- The network is flat — every pod reaches every pod
- CNI plugins make this work