curl -#OL carbide-apps.sh | sed -e 's/$DOMAIN/'$DOMAIN'/g' -e 's/$CarbideRegistry/'$CarbideRegistry'/g' | bash

### Enable Extensions
kubectl apply -f - <<EOF
apiVersion: catalog.cattle.io/v1
kind: ClusterRepo
metadata:
  name: rancher-ui-plugins
spec:
  gitBranch: main
  gitRepo: https://github.com/rancher/ui-plugin-charts
EOF

### Add Rancher Chart Repo
helm repo add rancher-charts https://charts.rancher.io
helm repo update

### Create Kubernetes Namespaces
kubectl create namespace cattle-ui-plugin-system
kubectl create namespace cattle-monitoring-system
kubectl create namespace cis-operator-system

### Install UI Plugin Operator and CRD
helm upgrade -i ui-plugin-operator rancher-charts/ui-plugin-operator -n cattle-ui-plugin-system --version=102.0.0+up0.2.0 --set global.cattle.systemDefaultRegistry=$CarbideRegistry

helm upgrade -i ui-plugin-operator-crd rancher-charts/ui-plugin-operator-crd -n cattle-ui-plugin-system --version=102.0.0+up0.2.0 --set global.cattle.systemDefaultRegistry=$CarbideRegistry

### Install Rancher Monitoring and CRD
helm upgrade -i rancher-monitoring-crd rancher-charts/rancher-monitoring-crd -n cattle-monitoring-system --version=102.0.1+up40.1.2 --set global.cattle.systemDefaultRegistry=$CarbideRegistry

helm upgrade -i rancher-monitoring rancher-charts/rancher-monitoring -n cattle-monitoring-system --version=102.0.1+up40.1.2 --set global.cattle.systemDefaultRegistry=$CarbideRegistry

### Install CIS Benchmarks and CRD
helm upgrade -i rancher-cis-benchmark-crd rancher-charts/rancher-cis-benchmark-crd -n cis-operator-system --version=3.0.0 --set global.cattle.url=https://rancher.$DOMAIN --set global.cattle.systemDefaultRegistry=$CarbideRegistry

helm upgrade -i rancher-cis-benchmark rancher-charts/rancher-cis-benchmark -n cis-operator-system --version=3.0.0 --set global.cattle.url=https://rancher.$DOMAIN --set global.cattle.systemDefaultRegistry=$CarbideRegistry

### Install Carbide License
kubectl create namespace carbide-docs-system
kubectl create namespace carbide-stigatron-system

kubectl create secret generic stigatron-license -n carbide-stigatron-system --from-literal=license=$CarbideLicense

### Install Carbide Applications
helm repo add carbide-charts https://rancherfederal.github.io/carbide-charts
helm repo add kubewarden https://charts.kubewarden.io
helm repo update

helm upgrade -i airgapped-docs carbide-charts/airgapped-docs -n carbide-docs-system --set global.cattle.systemDefaultRegistry=$CarbideRegistry

helm upgrade -i stigatron-ui carbide-charts/stigatron-ui -n carbide-stigatron-system --set global.cattle.systemDefaultRegistry=$CarbideRegistry

helm upgrade -i stigatron carbide-charts/stigatron -n carbide-stigatron-system --set global.cattle.systemDefaultRegistry=$CarbideRegistry --set heimdall2.heimdall.rcidf.registry=$CarbideRegistry --set heimdall2.global.cattle.systemDefaultRegistry=$CarbideRegistry

### Configure Classification Banners
kubectl apply -f https://raw.githubusercontent.com/zackbradys/code-templates/main/k8s/yamls/rancher-banner-ufouo.yaml