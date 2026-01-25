function create_cluster()
{
	k3d cluster create gitops -p "443:443@loadbalancer" -p "80:80@loadbalancer" -p "2222:22@loadbalancer"
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

	kubectl apply -n dev -f ./confs/playground-expose.yaml
}

function change_tls()
{
	# Install cert-manager
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.2/cert-manager.yaml
	
	# Wait for cert-manager to be available or wait at most 3min
	kubectl wait --for=condition=Available deployment --all -n cert-manager --timeout=180s

	kubectl apply -f ./confs/cert-manager.yaml

	# Change the argocd config map to add server.insecure property to true.
	# This is a patch to let argocd run with TLS enabled, by allowing self-cert for the API
	kubectl -n argocd get cm argocd-cmd-params-cm -o yaml | sed -e '$a\\ndata:\n  server.insecure: "true"\n' | kubectl replace -n argocd -f -

	kubectl apply -n argocd -f ./confs/argocd-ingress.yaml

	kubectl delete pods -n argocd "$(kubectl get pods | grep argocd-server | awk '{ print $1 }')"

	# Sleep 10s while k3d is goind to respawn all pods
	sleep 10

	# Wait for all pods at most 3min
	kubectl wait --for=condition=Available pods --all -n argocd --timeout=180s
}

function expose_port()
{
	change_tls

	echo "127.0.0.1 argocd.gitops.com gitops.com" >> /etc/hosts
}
