#!/bin/sh

if [ ! -f /usr/local/bin/k3s ]; then
	sudo wget -qO /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.5+k3s1/k3s
fi

if [ ! -f /usr/local/bin/kubectl ]; then
	sudo wget -qO /usr/local/bin/kubectl https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl
fi

sudo chmod +x /usr/local/bin/k3s /usr/local/bin/kubectl

if [ ! -f /etc/systemd/system/k3s.service.env ]; then
	sudo touch /etc/systemd/system/k3s.service.env
fi

sudo chmod 600 /etc/systemd/system/k3s.service.env


if [ ! -f /usr/local/bin/helm ]; then
	wget -q 'https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz' -O /tmp/helm-v3.9.0-linux-amd64.tar.gz
	tar -C /tmp -xf /tmp/helm-v3.9.0-linux-amd64.tar.gz
	mv /tmp/linux-amd64/helm /usr/local/bin/helm
	rm /tmp/helm-v3.9.0-linux-amd64.tar.gz
	rm -rf /tmp/linux-amd64
fi
