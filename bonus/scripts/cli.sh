function install_gitlab_cli()
{
	curl -sSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash

	sudo apt install glab -y
}

function login_gitlab_cli()
{
	glab config set skip_tls_verify true --host gitlab.gitops.com
	git config --global http.sslVerify false
	glab auth login --hostname gitlab.gitops.com --token "$1" --api-host gitlab.gitops.com:443 --api-protocol https --git-protocol ssh
}

function create_gitlab_repo()
{
	GITLAB_HOST=gitlab.gitops.com glab repo create pioupia --public -s --defaultBranch=main

	new_dir="$(mktemp -d)"
	cd $new_dir

	git init
	cp /root/inception-of-things/p3/confs/playground{,-service}.yaml .

	git checkout -b main

	git add .
	git commit -m "Initial commit"
	git remote add origin "https://root:$1@gitlab.gitops.com:443/root/pioupia.git"

	git push origin main

	rm -rf "$new_dir"
}


# Here, we need to create the API token for gitlab root user:
# https://forum.gitlab.com/t/gitlab-api-request-with-username-and-password/83662
# https://kubernetes.io/docs/reference/kubectl/jsonpath/
function insert_root_cli_token()
{
	kubectl wait --for=condition=Ready pod -l app=toolbox -n gitlab --timeout=120s

	node_name="$(kubectl get pods -n gitlab --selector=app=toolbox -o jsonpath='{.items[0].metadata.name}')"

	random_token="$1"

	# Take the date as second since EPOCH add 1 month in second take format
	expires_at="$(date -d "@$(( $(date +%s) + 31 * 24 * 60 * 60 ))" -I)"

	kubectl exec "$node_name" -it gitlab-rails -n gitlab -- gitlab-rails runner \
	'User.admins.first.personal_access_tokens.create(name: "apitoken", token_digest: Gitlab::CryptoHelper.sha256("'"$random_token"'"), scopes: [:api,:write_repository], expires_at: "'"$expires_at"'").save!'
}
