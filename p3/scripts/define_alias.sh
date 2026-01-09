function exec_as()
{
	user="$1"
	shift
	sudo -u "$user" /bin/bash -c "$@"
}

function define_kubernetees_alias()
{
	FILENAME=".bash_aliases"
	wget "https://raw.githubusercontent.com/ahmetb/kubectl-aliases/refs/heads/master/.kubectl_aliases" -q -O- \
		| tee -a /root/$FILENAME /home/test/$FILENAME /etc/skel/$FILENAME

	chown test:test /home/test/$FILENAME

	echo -ne 'if [ -f ~/.bash_aliases ]; then\n\t. ~/.bash_aliases\nfi' >> /root/.bashrc
}
