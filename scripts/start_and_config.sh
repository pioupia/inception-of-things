#!/bin/sh

# Start k3s service
sudo systemctl start k3s


export KUBECONFIG_PATH="/home/vagrant/.kube"

# Copy the k3s config for kubectl
mkdir -p "$KUBECONFIG_PATH"
sudo mkdir -p /root/.kube

# Share k3s config to other VM
if [ -f '/etc/rancher/k3s/k3s.yaml' ]; then
  sudo cp /etc/rancher/k3s/k3s.yaml "${KUBECONFIG_PATH}/config"
  sudo cp /etc/rancher/k3s/k3s.yaml "/root/.kube/config"
  sudo chown "$USER" "${KUBECONFIG_PATH}/config"
fi
