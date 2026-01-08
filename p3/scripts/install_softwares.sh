function prepare_docker_install() {
    sudo apt install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the APT respository
    sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
}

function prepare_kubectl_install() {
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
}

function install_software() {
    sudo apt-get update
    # apt-transport-https may be a dummy package; if so, you can skip that package
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

    prepare_docker_install
    prepare_kubectl_install

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin kubectl

    # Install k3d
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
}

function create_namespace()
{
    kubectl create namespace argocd
    kubectl create namespace dev

    # Change the current namespace
    kubectl config set-context --current --namespace=argocd
}

function install_argocd()
{
    create_namespace

    # The -n will set the default namespace to argocd and apply the config file
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
    wget -q -O /tmp/argocd-linux-amd64 'https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64'
    wget -q -O /tmp/cli_checksums.txt 'https://github.com/argoproj/argo-cd/releases/download/v$VERSION/cli_checksums.txt'

    pushd /tmp
    sha256sum --ignore-missing -c cli_checksums.txt
    if [ $? -ne 0 ]; then
        echo -n "An error has occured during the installation of argocd. The integrity verification through sha256sum failed. Do you want to continue? [y/N] "
        read -n1 res

        if [ "$res" != "y" ] && [ "$res" != "Y" ]; then
            exit 1
        fi
    fi
    popd

    sudo install -m 555 /tmp/argocd-linux-amd64 /usr/local/bin/argocd
    mv /tmp/argocd-linux-amd64 /bin/argocd
    rm /tmp/argocd-linux-amd64

    expose_port

    # Get the initial password:
    default_password="$(argocd admin initial-password -n argocd | head -1)"
    export default_password
}
