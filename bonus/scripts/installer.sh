function install_helm()
{
	wget -q -O /tmp/helm-linux-amd.tar.gz 'https://get.helm.sh/helm-v4.0.4-linux-amd64.tar.gz'
	echo "29454bc351f4433e66c00f5d37841627cbbcc02e4c70a6d796529d355237671c /tmp/helm-linux-amd.tar.gz" | sha256sum -c -

	if [ $? -ne 0 ]; then
		echo "The helm checksum is not valid. Please, check that manually" 1>&2
		exit 1
	fi

	tar -xf /tmp/helm-linux-amd.tar.gz
	mv linux-amd64/helm /usr/local/bin/helm
	rm -rf linux-amd64 /tmp/helm-linux-amd.tar.gz
}
