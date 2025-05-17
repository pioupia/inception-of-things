# -*- mode: ruby -*-

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.box_version = "12.20250126.1"

  # Provisionning with shell on both server and worker
  config.vm.provision "shell", inline: <<-SHELL
      sudo wget -O /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.5+k3s1/k3s
      sudo chmod a+x /usr/local/bin/k3s
SHELL

  # Change the hostname with the login of someone
  config.vm.define "pioupiaS" do |server|
    server.vm.hostname = "pioupiaS"
    server.vm.network "private_network", ip: "192.168.56.110"

    server.vm.provision "shell", inline: <<-SHELL
      echo "test" > /var/lib/rancher/k3s/server/node-token
      K3S_KUBECONFIG_MODE="644" sudo k3s server
SHELL

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.name = "pioupiaS"
    end
  end
  
  config.vm.define "pioupiaSW" do |worker|
    worker.vm.hostname = "pioupiaSW"
    worker.vm.network "private_network", ip: "192.168.56.111"

    worker.vm.provision "shell", inline: <<-SHELL
    # sudo cat /var/lib/rancher/k3s/server/node-token (on server)
    curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN='test' sh -
SHELL

    worker.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
      vb.name = "pioupiaSW"
    end
  end

end
