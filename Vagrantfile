# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

#  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box = "centos/7"

  (1..3).each do |i|
    config.vm.define "solr-#{i}" do |d|
      d.vm.hostname = "solr-#{i}"
      d.vm.network "private_network", ip: "10.100.199.20#{i}"
      d.vm.provider "virtualbox" do |v|
        v.memory = 1024
      end
      d.vm.provision "shell", path: "bootstrap.sh"
      d.vm.provision "ansible" do |ansible|
        ansible.playbook = "ansible/solr.yml"
      end
    end
  end

  if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
  end

end
