#!/bin/sh

export KUBECONFIG_PATH="/home/vagrant/.kube"

# Copy the k3s config for kubectl
mkdir -p "$KUBECONFIG_PATH"
sudo mkdir -p /root/.kube

# Share k3s config to other VM
if [ -f '/etc/rancher/k3s/k3s.yaml' ]; then
  sudo cp /etc/rancher/k3s/k3s.yaml "${KUBECONFIG_PATH}/config"
  sudo cp /etc/rancher/k3s/k3s.yaml "/root/.kube/config"
  sudo chown vagrant "${KUBECONFIG_PATH}/config"
else
  echo "K3s configuration file not found. Please ensure K3s is installed and running." 1>&2
  exit 1
fi
