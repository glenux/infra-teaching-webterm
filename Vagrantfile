# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 st=2 et :

# frozen_string_literal: true

# Setup & rules
class Infra
  GROUPS_COUNT = 1
  REPLICAS_COUNT = 2

  ## Utilities
  def self.gateway_name(index)
    "dev-gateway#{index}"
  end

  def self.mongo_name(index)
    "dev-server#{index}"
  end

  def self.gateway_ip(index)
    "192.168.50.#{250 - index * 5}"
  end

  def self.server_ip(index)
    "192.168.50.#{5 + index * 5}"
  end

  def self.role_mongo
    Infra::REPLICAS_COUNT.times.map { |i| mongo_name(i) }
  end

  def self.role_gateway
    Infra::GROUPS_COUNT.times.map { |i| gateway_name(i) }
  end
end

##
## Vagrant configuration
##

# rubocop:disable Metrics/BlockLength
Vagrant.configure('2') do |config|
  ##
  ## Common settings for virtual machines
  ##
  config.vm.box = 'debian/bullseye64'
  config.vm.box_check_update = false

  ##
  ## Web frontends
  ##
  Infra::GROUPS_COUNT.times do |index|
    config.vm.define Infra.gateway_name(index) do |machine|
      machine.vm.hostname = Infra.gateway_name(index)
      machine.vm.network 'private_network', ip: Infra.gateway_ip(index)
      machine.vm.provider 'virtualbox' do |vb|
        vb.memory = '4000'
        vb.gui = false
      end

      next if index.positive? # strictly positive (not null)

      # machine.vm.network 'forwarded_port', guest: 80, host: 1080
      # machine.vm.network 'forwarded_port', guest: 8080, host: 8080
    end
  end

  ##
  ## Mongo servers
  ##
  (Infra::GROUPS_COUNT * Infra::REPLICAS_COUNT).times do |index|
    config.vm.define Infra.mongo_name(index) do |machine|
      machine.vm.hostname = Infra.mongo_name(index)
      machine.vm.network 'private_network', ip: Infra.server_ip(index)
      machine.vm.provider 'virtualbox' do |vb|
        vb.memory = '3000'
        vb.gui = false
      end

      next if (index + 1) < (Infra::GROUPS_COUNT * Infra::REPLICAS_COUNT)

      machine.vm.provision 'ansible' do |ansible|
        # ansible.verbose = true
        ansible.playbook = 'ansible/playbook.yml'
        ansible.config_file = 'ansible/ansible.cfg'
        ansible.limit = 'all'
        ansible.groups = {
          'role_gateway' => Infra.role_gateway,
          'role_mongo' => Infra.role_mongo,
          'stage_development' => [Infra.role_mongo, Infra.role_gateway].flatten,
          'stage_production' => [],
          'stage_testing' => [],
          'all_groups:children' => %w[role_gateway role_mongo],
          'all:vars' => {
            'mongo_groups_count' => Infra::GROUPS_COUNT,
            'mongo_replicas_count' => Infra::REPLICAS_COUNT
          }
        }
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
