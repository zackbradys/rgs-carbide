### Configure Carbide License

In order to deploy Rancher Government Carbide, you must have an existing Carbide License Token. Please apply these YAMLS, before deploying Carbide with Fleet! To do this, replace `$CarbideLicense` with your License Token, then apply the YAMLS, then apply the Fleet command.

```bash
kubectl apply -f - <<EOF
### Create STIGATRON Namespace
apiVersion: v1
kind: Namespace
metadata:
  name: carbide-stigatron-system
  labels:
    kubernetes.io/metadata.name: carbide-stigatron-system
---
### Create STIGATRON License
apiVersion: v1
kind: Secret
metadata:
  name: stigatron-license
  namespace: carbide-stigatron-system
type: Opaque
data:
stringData:
  license: $CarbideLicense
EOF
```

### Fleet Local
```bash
### Deploys the app on the local cluster.
kubectl apply -f https://raw.githubusercontent.com/zackbradys/rgs-carbide/main/fleet/gitrepo-local.yaml
```

### Fleet Default
```bash
### Deploys the app to all downstream clusters.
kubectl apply -f https://raw.githubusercontent.com/zackbradys/rgs-carbide/main/fleet/gitrepo-default.yaml
```