#!/bin/sh

# Waiting at most 5 minutes the server setup it's file properly
for i in {1..60}; do
  if [ -f "/vagrant/shared/token" ]; then
    break
  fi
  sleep 5
done

# Install k3s 
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent -i ${WORKER_IP}" K3S_URL="https://$SERVER_IP:6443" K3S_TOKEN="$(cat /vagrant/shared/token)" sh -
