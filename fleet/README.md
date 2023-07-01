## Carbide Deployment with Fleet

### Configure Carbide License

In order to deploy Rancher Government Carbide, you must have an existing Carbide License on the exisiting cluster. Please apply these YAMLS, before deploying Carbide with Fleet! To do this, on each cluster, replace `$CarbideLicense` with your RGS provided License, apply the YAML to each cluster, and then apply the desired Fleet command.

```bash
kubectl create namespace carbide-stigatron-system && kubectl create secret generic stigatron-license -n carbide-stigatron-system --from-literal=license=$CarbideLicense
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