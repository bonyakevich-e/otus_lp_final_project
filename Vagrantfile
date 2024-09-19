# -*- mode: ruby -*-
# vim: set ft=ruby :

Vagrant.configure("2") do |config|
   
   config.vm.box = "bento/ubuntu-22.04"
   config.vm.provider "virtualbox" do |v| 
        v.memory = 4096 
        v.cpus = 2 
    end  

    config.vm.define "balancer" do |balancer|
      balancer.vm.host_name = "balancer"
      balancer.vm.network "public_network", ip: "192.168.30.20"
      balancer.vm.network "private_network", ip: "192.168.56.10"
    end

    config.vm.define "webserver1" do |webserver1|
      webserver1.vm.host_name = "webserver1"
      webserver1.vm.network "private_network", ip: "192.168.56.20"
    end

    config.vm.define "webserver2" do |webserver2|
      webserver2.vm.host_name = "webserver2"
      webserver2.vm.network "private_network", ip: "192.168.56.21"
    end

    config.vm.define "storage" do |storage|
      storage.vm.host_name = "storage"
      storage.vm.network "private_network", ip: "192.168.56.30"
    end

    config.vm.define "dbmaster" do |dbmaster|
      dbmaster.vm.host_name = "dbmaster"
      dbmaster.vm.network "private_network", ip: "192.168.56.40"
    end

    config.vm.define "dbslave" do |dbslave|
      dbslave.vm.host_name = "dbslave"
      dbslave.vm.network "private_network", ip: "192.168.56.41"
    end
    
    config.vm.define "monitoring" do |monitoring|
      monitoring.vm.host_name = "monitoring"
      monitoring.vm.network "private_network", ip: "192.168.56.60"
    end

    config.vm.define "backup" do |backup|
      backup.vm.host_name = "backup"
      backup.vm.network "private_network", ip: "192.168.56.50"
    end


end



