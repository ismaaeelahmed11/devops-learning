# ConfigMaps & Secrets

Both store configuration data for pods. ConfigMaps for non-sensitive data, Secrets for sensitive data.

---

## ConfigMaps

Store non-sensitive config: URLs, feature flags, environment names.

### Create a ConfigMap

Imperative:

```
kubectl create configmap my-config \
  --from-literal=APP_COLOUR=blue \
  --from-literal=APP_MODE=dev
```

Declarative (`configmap.yaml`):

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  APP_COLOUR: blue
  APP_MODE: dev
```

### Use a ConfigMap in a Pod

Two ways: as env vars, and as files.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: cm-demo
spec:
  containers:
    - name: demo-container
      image: busybox
      command: ["/bin/sh", "-c", "env && sleep 3600"]
      env:
        - name: APP_COLOUR
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: APP_COLOUR
        - name: APP_MODE
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: APP_MODE
      volumeMounts:
        - name: config-volume
          mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: my-config
```

### Verify

```
kubectl exec -it cm-demo -- env | grep APP_
ls /etc/config/
```

---

## Secrets

Store sensitive data: passwords, API keys, tokens.

### Create a Secret

```
kubectl create secret generic my-secret \
  --from-literal=Username=admin \
  --from-literal=Password=secret123
```

### Use a Secret in a Pod

Same pattern as ConfigMaps, but uses `secretKeyRef` and `secret:` volume.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-demo-pod
spec:
  containers:
    - name: secret-demo-container
      image: nginx
      env:
        - name: SECRET_USERNAME
          valueFrom:
            secretKeyRef:
              name: my-secret
              key: Username
        - name: SECRET_PASSWORD
          valueFrom:
            secretKeyRef:
              name: my-secret
              key: Password
      volumeMounts:
        - name: secret-volume
          mountPath: /etc/secret-volume
          readOnly: true
  volumes:
    - name: secret-volume
      secret:
        secretName: my-secret
```

### Verify

```
kubectl exec -it secret-demo-pod -- /bin/sh
echo $SECRET_USERNAME
cat /etc/secret-volume/Username
```

---

## ConfigMap vs Secret

| Feature | ConfigMap | Secret |
|---------|-----------|--------|
| Use case | Non-sensitive config | Passwords, keys, tokens |
| Storage format | Plain text | Base64-encoded |
| Create command | `kubectl create configmap` | `kubectl create secret generic` |
| Reference in pod | `configMapKeyRef` / `configMap` | `secretKeyRef` / `secret` |
| Encrypted at rest? | No | Not by default (must configure) |

---

## Common Mistakes

- **Case sensitivity** — `Username` ≠ `username`. Keys must match exactly.
- **Missing secret/configmap** — pod fails with `CreateContainerConfigError`
- **Wrong key name** — pod fails with "couldn't find key X in Secret Y"
- **Capital V in `VolumeMounts`** — YAML is case-sensitive. Must be `volumeMounts`.

---

## Debugging Commands

```
kubectl get configmap                    # list configmaps
kubectl get secret                       # list secrets
kubectl describe secret my-secret        # check keys
kubectl describe pod <pod>               # check events for errors
kubectl logs <pod>                       # see app output
```

---

## What I Learned

- ConfigMaps and Secrets separate config from code
- Same pod image, different config = different behaviour
- Secrets are base64-encoded, not encrypted by default
- Both can be mounted as files or injected as env vars
- Key names are case-sensitive
- Pod-level `volumes` and container-level `volumeMounts` are separate