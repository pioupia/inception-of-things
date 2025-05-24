#!/bin/sh

# Get the path of shared k3s config

for i in {1..30}; do
  if [ -f "/vagrant/shared/k3s.yaml" ]; then
	break
  fi
  sleep 2
done

if [ -f "/vagrant/shared/k3s.yaml" ]; then
  sudo mkdir -p /home/vagrant/.kube
  sudo mkdir -p /root/.kube

  sudo sed "s/127.0.0.1/$SERVER_IP/g" /vagrant/shared/k3s.yaml > /home/vagrant/.kube/config

  sudo rm /vagrant/shared/k3s.yaml

  sudo chmod 400 /home/vagrant/.kube/config

  sudo cp /home/vagrant/.kube/config /root/.kube/config

  sudo chown vagrant /home/vagrant/.kube/config
  sudo chown root /root/.kube/config
else
  echo "Shared k3s configuration file not found. Please ensure the server is running and the file is shared." 1>&2
  exit 1
fi

if [ -f "/vagrant/shared/token" ]; then
  sudo cp /vagrant/shared/token /root/.token
  sudo chmod 400 /root/.token
  sudo rm /vagrant/shared/token

  sudo systemctl start k3s
  sudo systemctl enable k3s
else
  echo "Shared k3s token file not found. Please ensure the server is running and the file is shared." 1>&2
  exit 1
fi