. ./scripts/deploy.sh
. ./scripts/installer.sh

install_helm

deploy_gitlab

kubectl rollout status deployment/gitlab-webservice-default -n gitlab --timeout=600s

initial_pass_gitlab="$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode ; echo)"

install_gitlab_cli

echo "=== Gitlab credentials ==="
echo "Username: admin"
echo "Password: $initial_pass_gitlab"
