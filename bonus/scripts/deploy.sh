function deploy_gitlab()
{
# 	helm repo add gitlab https://charts.gitlab.io/
# 	helm repo update
# 	helm upgrade --install gitlab gitlab/gitlab \
#   --timeout 600s \
#   --set global.hosts.domain=example.com \
#   --set global.hosts.externalIP=10.10.10.10 \
#   --set certmanager-issuer.email=me@example.com

	helm pull gitlab/gitlab --untar

	kubectl create namespace gitlab

	kubectl apply -f ./confs/gitlab-cert.yaml

	mv ./confs/gitab-values.yaml ./gitlab/values.yaml

	helm install gitlab ./gitlab/ -n gitlab

	echo "127.0.0.1 gitlab.gitops.com" >> /etc/hosts
}
