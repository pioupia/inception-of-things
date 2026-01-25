. ./scripts/deploy.sh
. ./scripts/installer.sh
. ./scripts/cli.sh

install_helm

deploy_gitlab

kubectl rollout status deployment/gitlab-webservice-default -n gitlab --timeout=720s

initial_pass_gitlab="$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode ; echo)"


# Setup gitlab repository
random_token="glpat-$(openssl rand -hex 64)"
insert_root_cli_token "$random_token"

install_gitlab_cli



login_gitlab_cli "$random_token"

create_gitlab_repo "$initial_pass_gitlab"


deploy_gitlab_on_argocd

echo "=== Gitlab credentials ==="
echo "Username: root"
echo "Password: $initial_pass_gitlab"
echo "Api Token: $random_token"
