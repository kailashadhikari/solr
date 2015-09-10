# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "puppetlabs/centos-6.6-64-puppet"

  (1..3).each do |i|
    config.vm.define "solr-#{i}" do |d|
      d.vm.hostname = "solr-#{i}"
      d.vm.network "private_network", ip: "10.100.199.20#{i}"
      d.vm.provider "virtualbox" do |v|
        v.memory = 1024
      end
      d.vm.provision "ansible" do |ansible|
        ansible.playbook = "ansible/solr.yml"
        # ansible.verbose = "vvvv"
      end
    end
  end

end
