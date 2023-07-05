## Carbide Deployment with Fleet

### Configure Carbide License

In order to deploy Rancher Government Carbide, you must following the steps below:
* Ensure the cluster(s) are configured with the Carbide images and private registry ([docs here](https://rancherfederal.github.io/carbide-docs/docs/registry-docs/kubernetes-config)).
* Apply the kubectl command below, while replacing `$CarbideLicense` with your RGS provided License
* Lastly, apply the Fleet command for each of the `local` or `downstream` cluster(s).

### Carbide License
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