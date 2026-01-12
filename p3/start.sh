. ./scripts/install_softwares.sh
. ./scripts/config.sh
. ./scripts/define_alias.sh

install_software

create_cluster

define_kubernetees_alias

install_argocd

create_app

# Get the initial password:
default_password="$(argocd admin initial-password -n argocd | head -1)"
echo "=== ArgoCD credentials ==="
echo "Username: admin"
echo "Password: $default_password"
