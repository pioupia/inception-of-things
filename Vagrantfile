# -*- mode: ruby -*-

# Machines configurations
SERVICES = {
  'server' => {
    ip: '192.168.56.110',
  },
  'worker' => {
    ip: '192.168.56.111',
  }
}

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.box_version = "12.20250126.1"

  config.vm.synced_folder "./shared", "/vagrant/shared", create: true, type: "virtualbox"

  # Provisionning with shell on both server and worker
  config.vm.provision "shell", inline: <<-SHELL
      sudo wget -qO /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.5+k3s1/k3s
      sudo wget -qO /usr/local/bin/kubectl https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl
      sudo chmod +x /usr/local/bin/k3s /usr/local/bin/kubectl
      sudo touch /etc/systemd/system/k3s.service.env
      sudo chmod u=rw,g=,o= /etc/systemd/system/k3s.service.env
SHELL

  # Change the hostname with the login of someone
  config.vm.define "pioupiaS" do |server|
    server.vm.hostname = "pioupiaS"
    server.vm.network "private_network", ip: SERVICES['server'][:ip]

    server.vm.provision "file", source: "./services/k3s_server.service", destination: "/tmp/k3s.service"

    server.vm.provision "shell", inline: <<-SHELL
      sudo mv "/tmp/k3s.service" /etc/systemd/system/k3s.service

      sudo -- bash -c 'echo "SERVER_IP=#{SERVICES['server'][:ip]}" >> /etc/systemd/system/k3s.service.env'
      sudo systemctl start k3s
SHELL

    server.vm.provision "shell", path: "./scripts/server_configuration.sh"

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
      vb.name = "pioupiaS"
    end
  end
  
  config.vm.define "pioupiaSW" do |worker|
    worker.vm.hostname = "pioupiaSW"
    worker.vm.network "private_network", ip: SERVICES['worker'][:ip]

    worker.vm.provision "file", source: "./services/k3s_worker.service", destination: "/tmp/k3s.service"

    worker.vm.provision "shell", inline: <<-SHELL
      sudo mv "/tmp/k3s.service" /etc/systemd/system/k3s.service

      sudo -- bash -c 'echo "SERVER_URI=https://#{SERVICES['server'][:ip]}:6443" >> /etc/systemd/system/k3s.service.env'
      sudo -- bash -c 'echo "WORKER_IP=#{SERVICES['worker'][:ip]}" >> /etc/systemd/system/k3s.service.env'
SHELL

    worker.vm.provision "shell", path: "./scripts/worker_configuration.sh", env: { "SERVER_IP" => SERVICES['server'][:ip] }

    worker.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
      vb.name = "pioupiaSW"
    end
  end

end
