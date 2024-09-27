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

### Add Classification Banners
kubectl apply -f - <<EOF
apiVersion: management.cattle.io/v3
customized: false
default: '{}'
kind: Setting
metadata:
  name: ui-banners
value: '{"loginError":{"message":"","showMessage":"false"},"bannerHeader":{"background":"#007a33","color":"#ffffff","textAlignment":"center","fontWeight":null,"fontStyle":null,"fontSize":"14px","textDecoration":null,"text":"UNCLASSIFIED//FOUO"},"bannerFooter":{"background":"#007a33","color":"#ffffff","textAlignment":"center","fontWeight":null,"fontStyle":null,"fontSize":"14px","textDecoration":null,"text":"UNCLASSIFIED//FOUO"},"bannerConsent":{"background":"#eeeff4","color":"#141419","textAlignment":"center","fontWeight":null,"fontStyle":null,"fontSize":"14px","textDecoration":null,"text":"You
  are accessing a U.S. Government (USG) Information System (IS) that is provided for
  USG-authorized use only.\\nBy using this IS (which includes any device attached
  to this IS), you consent to the following conditions: The USG routinely intercepts
  and monitors communications on this IS for purposes including, but not limited to,
  penetration testing, COMSEC monitoring, network operations and defense, personnel
  misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.
  At any time, the USG may inspect and seize data stored on this IS. Communications
  using, or data stored on, this IS are not private, are subject to routine monitoring,
  interception, and search, and may be disclosed or used for any USG-authorized purpose.
  This IS includes security measures (e.g., authentication and access controls) to
  protect USG interests--not for your personal benefit or privacy. Notwithstanding
  the above, using this IS does not constitute consent to PM, LE or CI investigative
  searching or monitoring of the content of privileged communications, or work product,
  related to personal representation or services by attorneys, psychotherapists, or
  clergy, and their assistants. Such communications and work product are private and
  confidential.\\n See User Agreement for details.","button":"Accept"},"showHeader":"true","showFooter":"true","showConsent":"true"}'
EOF

### Add Rancher Chart Repo
helm repo add rancher-charts https://charts.rancher.io
helm repo update

### Create Kubernetes Namespaces
kubectl create namespace cattle-ui-plugin-system
kubectl create namespace cis-operator-system

### Install UI Plugin Operator and CRD
helm upgrade -i ui-plugin-operator rancher-charts/ui-plugin-operator -n cattle-ui-plugin-system --version=103.0.2+up0.2.1 --set global.cattle.systemDefaultRegistry=$CarbideRegistry

sleep 10

helm upgrade -i ui-plugin-operator-crd rancher-charts/ui-plugin-operator-crd -n cattle-ui-plugin-system --version=103.0.2+up0.2.1 --set global.cattle.systemDefaultRegistry=$CarbideRegistry

### Install CIS Benchmarks and CRD
helm upgrade -i rancher-cis-benchmark-crd rancher-charts/rancher-cis-benchmark-crd -n cis-operator-system --version=6.1.0 --set global.cattle.url=https://rancher.$DOMAIN --set global.cattle.systemDefaultRegistry=$CarbideRegistry

sleep 10

helm upgrade -i rancher-cis-benchmark rancher-charts/rancher-cis-benchmark -n cis-operator-system --version=6.1.0 --set global.cattle.url=https://rancher.$DOMAIN --set global.cattle.systemDefaultRegistry=$CarbideRegistry

sleep 30

### Install Carbide License
kubectl create namespace carbide-docs-system
kubectl create namespace carbide-stigatron-system

kubectl create secret generic stigatron-license -n carbide-stigatron-system --from-literal=license=$CarbideLicense

### Install Carbide Applications
helm repo add carbide-charts https://rancherfederal.github.io/carbide-charts
helm repo add kubewarden https://charts.kubewarden.io
helm repo update

helm upgrade -i airgapped-docs carbide-charts/airgapped-docs -n carbide-docs-system --version=0.1.51 --set global.cattle.systemDefaultRegistry=$CarbideRegistry

helm upgrade -i stigatron-ui carbide-charts/stigatron-ui -n carbide-stigatron-system --version=0.3.0 --set global.cattle.systemDefaultRegistry=$CarbideRegistry

helm upgrade -i stigatron carbide-charts/stigatron -n carbide-stigatron-system --version=0.3.0 --set global.cattle.systemDefaultRegistry=$CarbideRegistry --set heimdall2.heimdall.rcidf.registry=$CarbideRegistry --set heimdall2.global.cattle.systemDefaultRegistry=$CarbideRegistry
