. ./scripts/install_softwares.sh
. ./scripts/config.sh
. ./scripts/define_alias.sh

install_software

create_cluster

define_kubernetees_alias

install_argocd

create_app

echo "Username: admin"
echo "Password: $default_password"
