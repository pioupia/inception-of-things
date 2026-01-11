function install_gitlab_cli()
{
	curl -sSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash

	sudo apt install glab -y
}
