### Add Rancher Extensions Chart Repo
kubectl apply -f - <<EOF
apiVersion: catalog.cattle.io/v1
kind: ClusterRepo
metadata:
  name: rancher-extensions
spec:
  gitBranch: main
  gitRepo: https://github.com/rancher/ui-plugin-charts
EOF

### Add Rancher Partner Extensions Chart Repo
kubectl apply -f - <<EOF
apiVersion: catalog.cattle.io/v1
kind: ClusterRepo
metadata:
  name: rancher-partner-extensions
spec:
  gitBranch: main
  gitRepo: https://github.com/rancher/partner-extensions
EOF

### Add Rancher Government Carbide Chart Repo
kubectl apply -f - <<EOF
apiVersion: catalog.cattle.io/v1
kind: ClusterRepo
metadata:
  name: carbide-charts
spec:
  gitBranch: main
  gitRepo: https://github.com/rancherfederal/carbide-charts
EOF

### Add Rancher Chart Repo
helm repo add rancher-charts https://charts.rancher.io
helm repo update

### Create Kubernetes Namespaces
kubectl create namespace cis-operator-system
kubectl create namespace carbide-stigatron-system

### Install CIS Benchmarks and CRD
helm upgrade -i rancher-cis-benchmark-crd rancher-charts/rancher-cis-benchmark-crd -n cis-operator-system --version=6.6.0 --set global.cattle.url=https://rancher.$DOMAIN --set global.cattle.systemDefaultRegistry=$CarbideRegistry

sleep 10

helm upgrade -i rancher-cis-benchmark rancher-charts/rancher-cis-benchmark -n cis-operator-system --version=6.6.0 --set global.cattle.url=https://rancher.$DOMAIN --set global.cattle.systemDefaultRegistry=$CarbideRegistry

sleep 30

### Install Carbide License
kubectl create secret generic stigatron-license -n carbide-stigatron-system --from-literal=license=$CarbideLicense

### Install Carbide Applications
helm repo add carbide-charts https://rancherfederal.github.io/carbide-charts
helm repo add kubewarden https://charts.kubewarden.io
helm repo update

helm upgrade -i stigatron carbide-charts/stigatron -n carbide-stigatron-system --version=0.4.0 --set global.cattle.systemDefaultRegistry=$CarbideRegistry --set heimdall2.heimdall.rcidf.registry=$CarbideRegistry --set heimdall2.global.cattle.systemDefaultRegistry=$CarbideRegistry
