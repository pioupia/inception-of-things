function install_helm()
{
	wget -q -O /tmp/helm-linux-amd.tar.gz 'https://get.helm.sh/helm-v4.1.0-linux-amd64.tar.gz'
	echo "8e7ae5cb890c56f53713bffec38e41cd8e7e4619ebe56f8b31cd383bfb3dbb83 /tmp/helm-linux-amd.tar.gz" | sha256sum -c -

	if [ $? -ne 0 ]; then
		echo "The helm checksum is not valid. Please, check that manually" 1>&2
		exit 1
	fi

	tar -xf /tmp/helm-linux-amd.tar.gz
	mv linux-amd64/helm /usr/local/bin/helm
	rm -rf linux-amd64 /tmp/helm-linux-amd.tar.gz
}
