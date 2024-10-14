
## Carbide Deployment with Fleet

### Deployment Options

In order to deploy Rancher Government Carbide, you have two deployment options. You can deploy it **only** on the **`local` cluster** or on **all** the **`local` and `downstream` clusters**.
* Ensure the cluster(s) are configured with the Carbide images and private registry ([docs here](https://rancherfederal.github.io/carbide-docs/docs/registry-docs/kubernetes-config)).
* Apply the shell variables, while replacing `$DOMAIN`, `$CarbideRegistry`, and `$CarbideLicense`.
* Lastly, apply the curl command to each of the `local` or `downstream` cluster(s).

### Carbide Local Script
```bash
### Set Script Variables
export DOMAIN=domain.url
export CarbideRegistry=registry.url
export CarbideLicense=license

### Run the Carbide Local Script
curl -#OL https://raw.githubusercontent.com/zackbradys/rgs-carbide/main/shell/carbide-local.sh
```

### Carbide Default Script
```bash
### Set Script Variables
export DOMAIN=domain.url
export CarbideRegistry=registry.url
export CarbideLicense=license

### Run the Carbide Default Script
curl -#OL https://raw.githubusercontent.com/zackbradys/rgs-carbide/main/shell/carbide-default.sh
```
