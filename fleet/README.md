## Carbide Deployment with Fleet

### Deployment Instructions
* Ensure each cluster (`local` and `downstream`) are configured to the Carbide Secured Registry (CSR) or a Private Registry with all the Carbide Images ([docs here](https://rancherfederal.github.io/carbide-docs/docs/registry-docs/kubernetes-config)).
* Apply the Fleet GitRepo commands from below to the `local` cluster.
* Apply the kubectl command below to each of the clusters, while replacing `$CarbideLicense` with your RGS Carbide License Key.
* Lastly, add a Cluster Label of `carbide=enabled` to each of the clusters and Fleet will automatically deploy all resources.

### Carbide License
```bash
kubectl create namespace carbide-stigatron-system
kubectl create secret generic stigatron-license -n carbide-stigatron-system --from-literal=license=$CarbideLicense
```

### Fleet Local
```bash
### Adds the GitRepo to the local cluster.
kubectl apply -f https://raw.githubusercontent.com/zackbradys/rgs-carbide/main/fleet/gitrepo-local.yaml
```

### Fleet Default
```bash
### Adds the GitRepo to all downstream cluster(s).
kubectl apply -f https://raw.githubusercontent.com/zackbradys/rgs-carbide/main/fleet/gitrepo-default.yaml
```
