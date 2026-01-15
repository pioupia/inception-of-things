#!/bin/sh

if [ ! -f /usr/local/bin/helm ]; then
	wget -q 'https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz' -O /tmp/helm-v3.9.0-linux-amd64.tar.gz
	tar -C /tmp -xf /tmp/helm-v3.9.0-linux-amd64.tar.gz
	mv /tmp/linux-amd64/helm /usr/local/bin/helm
	rm /tmp/helm-v3.9.0-linux-amd64.tar.gz
	rm -rf /tmp/linux-amd64
fi
