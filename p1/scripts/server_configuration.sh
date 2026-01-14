#!/bin/sh

export KUBECONFIG_PATH="/home/vagrant/.kube"
mkdir -p "$KUBECONFIG_PATH"

if [ -f "/var/lib/rancher/k3s/server/token" ]; then
  sudo cp /var/lib/rancher/k3s/server/token "/vagrant/shared/"
else
  echo "K3s token file not found. Please ensure K3s is installed and running." 1>&2
  exit 1
fi
