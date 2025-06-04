sudo -- bash -c 'echo "SERVER_IP=#{SERVICES['server'][:ip]}" >> /etc/systemd/system/k3s.service.env'
sudo systemctl start k3s
sudo systemctl enable k3s
