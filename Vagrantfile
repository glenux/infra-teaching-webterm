# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 st=2 et :

# frozen_string_literal: true
require 'fileutils'

# Setup & rules
class Infra
  TYPE_GATEWAY = :gateway
  TYPE_SERVER = :server

  GROUPS_COUNT = 1
  REPLICAS_COUNT = 2
  MACADDR_OUI = '080027' # Registered for Oracle VirtualBox 5.2+

  ## Utilities
  def self.hostname(type, index)
    case type
    when TYPE_GATEWAY then "dev-gateway#{index}"
    when TYPE_SERVER then "dev-server#{index}"
    end
  end

  def self.macaddr(type, index)
    case type
    when TYPE_GATEWAY then MACADDR_OUI + format('%06x', 250 - index * 5)
    when TYPE_SERVER then MACADDR_OUI + format('%06x', 250 - index * 5)
    end
  end

  def self.ipaddr(type, index)
    case type
    when TYPE_GATEWAY then "192.168.50.#{250 - index * 5}"
    when TYPE_SERVER then "192.168.50.#{5 + index * 5}"
    end
  end

  def self.group(type)
    case type
    when TYPE_GATEWAY then Infra::GROUPS_COUNT.times.map { |i| hostname(type, i) }
    when TYPE_SERVER then (Infra::GROUPS_COUNT * Infra::REPLICAS_COUNT).times.map { |i| hostname(type, i) }
    end
  end

  def self.metadata(type, index)
    case type
    when TYPE_GATEWAY then
      {
        webconsole_group_id: index,
        webconsole_group_index: 0,
        webconsole_ipaddr: ipaddr(type, index)
      }
    when TYPE_SERVER then
      {
        webconsole_group_id: (index / REPLICAS_COUNT).to_i,
        webconsole_group_index: (index % REPLICAS_COUNT),
        webconsole_ipaddr: ipaddr(type, index)
      }
    end
  end

  def self.group_metadata(type)
    case type
    when TYPE_GATEWAY
      Infra::GROUPS_COUNT.times.map do |i|
        [hostname(type, i), metadata(type, i)]
      end.to_h
    when TYPE_SERVER
      (Infra::GROUPS_COUNT * Infra::REPLICAS_COUNT).times.map do |i|
        [hostname(type, i), metadata(type, i)]
      end.to_h
    end
  end

  def self.generate_certs(type, index)
    ipaddr = Infra.ipaddr(type, index)
    return if File.exist? "minica/#{ipaddr}"

    FileUtils.mkdir_p 'minica'
    system "cd minica && minica -ip-addresses #{ipaddr}"
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
    config.vm.define Infra.hostname(Infra::TYPE_GATEWAY, index) do |machine|
      machine.vm.hostname = Infra.hostname(Infra::TYPE_GATEWAY, index)
      machine.vm.network(
        'private_network',
        ip: Infra.ipaddr(Infra::TYPE_GATEWAY, index),
        mac: Infra.macaddr(Infra::TYPE_GATEWAY, index)
      )
      machine.vm.provider 'virtualbox' do |vb|
        vb.memory = '4000'
        vb.gui = false
      end

      machine.trigger.after :up do |trigger|
        trigger.info = "Generating certificates for #{machine.vm.hostname}"
        trigger.ruby do |_env, _machine|
          Infra.generate_certs(Infra::TYPE_GATEWAY, index)
        end
      end

      # next if index.positive? # strictly positive (not null)
      # machine.vm.network 'forwarded_port', guest: 80, host: 1080
      # machine.vm.network 'forwarded_port', guest: 8080, host: 8080
    end
  end

  ##
  ## Mongo servers
  ##
  (Infra::GROUPS_COUNT * Infra::REPLICAS_COUNT).times do |index|
    type = Infra::TYPE_SERVER
    config.vm.define Infra.hostname(type, index) do |machine|
      machine.vm.hostname = Infra.hostname(type, index)
      machine.vm.network(
        'private_network',
        ip: Infra.ipaddr(type, index),
        mac: Infra.macaddr(type, index)
      )
      machine.vm.provider 'virtualbox' do |vb|
        vb.memory = '3000'
        vb.gui = false
      end

      machine.trigger.after :up do |trigger|
        trigger.info = "Generating certificates for #{machine.vm.hostname}"
        trigger.ruby do |_env, _machine|
          Infra.generate_certs(type, index)
        end
      end

      next if (index + 1) < (Infra::GROUPS_COUNT * Infra::REPLICAS_COUNT)

      machine.vm.provision 'ansible' do |ansible|
        # ansible.verbose = true
        ansible.playbook = 'ansible/playbook.yml'
        ansible.config_file = 'ansible/ansible.cfg'
        ansible.limit = 'all'
        ansible.host_vars = [
          Infra.group_metadata(Infra::TYPE_SERVER),
          Infra.group_metadata(Infra::TYPE_GATEWAY)
        ].reduce({}, :merge)
        ansible.groups = {
          'role_gateway' => Infra.group(Infra::TYPE_GATEWAY),
          'role_mongo' => Infra.group(Infra::TYPE_SERVER),
          'stage_development' => [
            Infra.group(Infra::TYPE_SERVER),
            Infra.group(Infra::TYPE_GATEWAY)
          ].flatten,
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
