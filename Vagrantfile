# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 st=2 et :

# frozen_string_literal: true

SERVERS_COUNT=3

Vagrant.configure('2') do |config|
  # Common settings for virtual machines
  config.vm.box = 'debian/bullseye64'
  config.vm.box_check_update = false

  ##
  ## gateway: Guacamole proxy + entrypoint
  ##
  config.vm.define 'gateway' do |machine|
    machine.vm.hostname = 'gateway'
    machine.vm.network 'private_network', ip: '192.168.50.250'
    machine.vm.network 'forwarded_port', guest: 80, host: 1080
    machine.vm.network 'forwarded_port', guest: 8080, host: 8080
    machine.vm.provider 'virtualbox' do |vb|
      vb.memory = '4000'
      vb.gui = false
    end
  end

  ##
  ## serverX : host servers with mongo, etc
  ##
  server_ip = ->(index) { "192.168.50.#{10 + index * 10}" }
  SERVERS_COUNT.times do |index|
    config.vm.define "server#{index}" do |machine|
      machine.vm.hostname = "server#{index}"
      machine.vm.network 'private_network', ip: server_ip.call(index)
      machine.vm.provider 'virtualbox' do |vb|
        vb.memory = '3000'
        vb.gui = false
      end
    end
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'ansible/playbook.yml'
    # ansible.verbose = true
    ansible.config_file = 'ansible/ansible.cfg'
    ansible.groups = {
      'app_sshwifty' => ['gateway'],
      'app_mongo' => SERVERS_COUNT.times.map { |i| "server#{i}" },
      'all_groups:children' => ['app_mongo']
    }
  end
end
