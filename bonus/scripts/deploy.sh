function deploy_gitlab()
{
	helm pull gitlab/gitlab --untar

	kubectl create namespace gitlab

	kubectl apply -f ./confs/gitlab-cert.yaml

	mv ./confs/gitab-values.yaml ./gitlab/values.yaml

	helm install gitlab ./gitlab/ -n gitlab

	echo "127.0.0.1 gitlab.gitops.com" >> /etc/hosts
}

function delete_stuck_namespace()
{
	kubectl get namespace "$1" -o json \
  | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \
  | kubectl replace --raw /api/v1/namespaces/$1/finalize -f -
}

function undeploy()
{
	# 1. Supprimer la release Helm
	helm uninstall gitlab -n gitlab

	# 2. Supprimer TOUTES les données (très important pour Postgres)
	kubectl delete pvc --all -n gitlab

	# 3. Attendre que les PVC disparaissent
	sleep 10

	# 4. Supprimer le reste pour éviter les conflits de secrets
	kubectl delete secret --all -n gitlab
	kubectl delete cm --all -n gitlab

	delete_stuck_namespace gitlab
}

