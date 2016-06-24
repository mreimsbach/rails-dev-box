# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box      = 'fitmentgroup/rvmruby222'
  config.vm.hostname = 'rails-dev-box'

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 3001, host: 3001
  config.vm.network :forwarded_port, guest: 3306, host: 3306
  config.vm.network :forwarded_port, guest: 5000, host: 5000
  config.vm.network :forwarded_port, guest: 8982, host: 8982
  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true
  config.vm.network :private_network, ip: "192.168.10.50"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
end
