# Kubernetes Storage

Containers are ephemeral — when a pod dies, its filesystem goes with it. Storage lets data survive.

---

## Key Concepts

### PersistentVolume (PV)
- Cluster-level storage resource
- Survives pod restarts
- Backed by cloud disks (EBS), NFS, local disk, etc.
- Admin-provisioned or dynamically created

### PersistentVolumeClaim (PVC)
- A pod's request for storage
- "I need 5GB of read-write storage"
- Kubernetes binds it to a matching PV

---

## PV vs PVC

| PersistentVolume (PV) | PersistentVolumeClaim (PVC) |
|-----------------------|---------------------------|
| The actual storage | A request for storage |
| Created by admin (or dynamically) | Created by the user |
| Cluster-scoped | Namespace-scoped |
| Like a hard drive | Like a ticket for a hard drive |

---

## How It Works

```
Pod → PVC → PV → Actual Storage
```

1. Pod says "I need storage" via a PVC
2. Kubernetes finds a matching PV
3. Binds them together
4. Pod mounts the storage

---

## Access Modes

| Mode | Meaning |
|------|---------|
| ReadWriteOnce (RWO) | One node can read/write |
| ReadOnlyMany (ROX) | Many nodes can read |
| ReadWriteMany (RWX) | Many nodes can read/write |

---

## Dynamic Provisioning

Instead of admins manually creating PVs, Kubernetes can create them on demand:

1. Pod creates a PVC
2. StorageClass provisions a PV automatically
3. Bound to the PVC
4. Pod mounts it

Kind comes with a default StorageClass for local testing.

---

## Key Commands

```
kubectl get pv                    # list persistent volumes
kubectl get pvc                   # list persistent volume claims
kubectl describe pvc my-pvc       # see status, bound PV
kubectl get storageclass          # list storage classes
```

---

## What I Learned

- Containers are ephemeral, storage must persist separately
- PV = the actual storage, PVC = the request for it
- Pods reference PVCs, not PVs directly
- Dynamic provisioning creates PVs on demand
- Kind has a default StorageClass for local testing
- Cloud uses EBS-backed volumes in production