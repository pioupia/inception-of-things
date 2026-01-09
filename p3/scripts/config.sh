function create_cluster()
{
	k3d cluster create gitops -p "8443:443@loadbalancer" -p "8080:80@loadbalancer"
}

function create_app()
{
	argocd app create playground \
		--repo https://github.com/pioupia/pioupia-iot_app.git \
		--path . \
		--dest-server https://kubernetes.default.svc \
		--dest-namespace dev

	# Sync with CLI the playground application
	argocd app sync playground

	# Define autosync of playground
	argocd app set playground --sync-policy automated
}

function change_tls()
{
	# Install cert-manager
	kubectl apply -f ./confs/cert-manager.yaml

	kubectl -n argocd get argocd-cmd-params-cm -o yaml | sed -e '$a\\ndata:\n  server.insecure: "true"\n' | kubectl replace -n argocd -f -

	kubectl apply -n argocd -f ./confs/argocd-ingress.yaml

	kubectl delete pods -n argocd "$(k get pods | grep argocd-server | awk '{ print $1 }')"
}

function expose_port()
{
	# Expose argocd locally:
    # kubectl port-forward svc/argocd-server -n argocd 8080:443 &

	change_tls

	echo "127.0.0.1 argocd.gitops.com" >> /etc/hosts
}
