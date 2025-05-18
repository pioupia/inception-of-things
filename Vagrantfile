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
      sudo wget -qO /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.5+k3s1/k3s
      sudo wget -qO /usr/local/bin/kubectl https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl
      sudo chmod +x /usr/local/bin/k3s /usr/local/bin/kubectl
SHELL

  # Change the hostname with the login of someone
  config.vm.define "pioupiaS" do |server|
    server.vm.hostname = "pioupiaS"
    server.vm.network "private_network", ip: "192.168.56.110"

    server.vm.provision "shell", inline: <<-SHELL
      sudo k3s server --token=test --cluster-init -i 192.168.56.110 &
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
    sudo k3s agent --token test --server https://192.168.56.110:6443 -i 192.168.56.111 &
SHELL

    worker.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
      vb.name = "pioupiaSW"
    end
  end

end
