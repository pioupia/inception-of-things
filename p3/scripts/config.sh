function create_cluster()
{
	k3d cluster create gitops
}

function create_app()
{
	mkdir -p /etc/rancher/k3s/
	ln -s /root/.kube/config /etc/rancher/k3s/k3s.yaml

	argocd app create playground \
		--repo https://github.com/pioupia/pioupia-iot_app \
		--path . \
		--dest-server https://kubernetes.default.svc \
		--dest-namespace dev

	# Sync with CLI the playground application
	argocd app sync playground
}

function expose_port()
{
	# Expose argocd locally:
    kubectl port-forward svc/argocd-server -n argocd 8080:443 &
}
