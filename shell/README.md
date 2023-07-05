## Carbide Deployment with Script

In order to deploy Rancher Government Carbide, you must following the steps below:
* Ensure the cluster(s) are configured with the Carbide images and private registry ([docs here](https://rancherfederal.github.io/carbide-docs/docs/registry-docs/kubernetes-config)).
* Apply the exported variables, while replacing `$DOMAIN`, `$CarbideRegistry`, and `$CarbideLicense`.
* Lastly, apply the curl command for each cluster(s).

### Carbide Script
```bash
### Set Script Variables
export DOMAIN=domain.url
export CarbideRegistry=registry.url
export CarbideLicense=license

### Run the Carbide Script
curl -#OL https://raw.githubusercontent.com/zackbradys/rgs-carbide/main/shell/carbide-apps.sh
```