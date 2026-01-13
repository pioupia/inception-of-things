. ./scripts/deploy.sh
. ./scripts/installer.sh

install_helm

deploy_gitlab

kubectl rollout status deployment/gitlab-webservice-default -n gitlab --timeout=600s

initial_pass_gitlab="$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode ; echo)"

# Useless for the project, but we could install gitlab CLI:
# install_gitlab_cli

update_argocd_dns

echo "=== Gitlab credentials ==="
echo "Username: root"
echo "Password: $initial_pass_gitlab"
