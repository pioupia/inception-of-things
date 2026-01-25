function install_helm()
{
	wget -q -O /tmp/helm-linux-amd.tar.gz 'https://get.helm.sh/helm-v3.20.0-linux-amd64.tar.gz'
	echo "dbb4c8fc8e19d159d1a63dda8db655f9ffa4aac1b9a6b188b34a40957119b286 /tmp/helm-linux-amd.tar.gz" | sha256sum -c -

	if [ $? -ne 0 ]; then
		echo "The helm checksum is not valid. Please, check that manually" 1>&2
		exit 1
	fi

	tar -xf /tmp/helm-linux-amd.tar.gz
	mv linux-amd64/helm /usr/local/bin/helm
	rm -rf linux-amd64 /tmp/helm-linux-amd.tar.gz
}
