# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load YAML lib
require 'yaml'

# Centralized config file
configYamlPath = "dev-config.yml"

# Try to import config file
if File.exist? configYamlPath then
    settings = YAML::load(File.read(configYamlPath))
else
    abort "Dev config file not found."
end

# Assign Vagrant required version
Vagrant.require_version ">="+settings['vagrant_minimum_version']

# Install plugins
unless settings['vagrant_plugins'].empty?
    settings['vagrant_plugins'].each do |plugin|
        pluginName = plugin['name']
        manager = Vagrant::Plugin::Manager.instance

        # Check if plugin is already installed
        next if manager.installed_plugins.key?(pluginName)

        manager.install_plugin(
            pluginName,
            sources: plugin.fetch('source', %w[https://rubygems.org/ https://gems.hashicorp.com/]),
            version: plugin['version']
        )
    end
end

# Initiate Vagrant VM configuration
Vagrant.configure(settings['vagrant_api_version']) do |config|

    # We based our env on VirtualBox
    config.vm.provider "virtualbox"

    # SSH standard definitions
    config.ssh.insert_key = false
    config.ssh.forward_agent = true

    config.vbguest.auto_update = false

    # Defining project name
    config.vm.define settings['project_name']

    # Networking configuration.
    config.vm.hostname = settings['hostname']
    unless settings['ip'].empty?
        config.vm.network "private_network", ip: settings['ip'],
            auto_network: settings['ip'] == '0.0.0.0' && Vagrant.has_plugin?('vagrant-auto_network')
    end

    # Merge all hosts and aliases to array
    hosts = Array.new
    hosts = hosts.push(settings['hostname'])
    unless settings['hostname_aliases'].empty?
        settings['hostname_aliases'].each do |newAlias|
            if newAlias.key?("name")
                unless ( newAlias['name'].nil? || newAlias['name'].empty? )
                    hosts = hosts.push(newAlias['name'])
                end
            end
        end
    end

    # Manage hosts file to locally point to IP address
    if Vagrant.has_plugin?('vagrant-hostsupdater')
        config.hostsupdater.aliases = hosts
    elsif Vagrant.has_plugin?('vagrant-hostmanager')
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
        config.hostmanager.aliases = hosts
    end

    # Vagrant box and version
    config.vm.box = settings['vagrant_box']
    unless settings['vagrant_box_version'].empty?
        config.vm.box_version = settings['vagrant_box_version']
    end

    # Use Default Port Forwarding Unless Overridden
    if settings.has_key?('vagrant_default_ports')
        settings['vagrant_default_ports'].each do |port|
          config.vm.network 'forwarded_port', guest: port['guest'], host: port['host'], auto_correct: true
        end
    end

    # VirtualBox
    config.vm.provider :virtualbox do |v|
        v.linked_clone = true
        v.name = settings['project_name']

        # Configure VM resources
        v.customize ['modifyvm', :id, '--memory', settings['vagrant_memory'] ||= '2048']
        v.customize ['modifyvm', :id, '--cpus', settings['vagrant_cpus'] ||= '1']
        v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
        v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        v.customize ['modifyvm', :id, '--cableconnected1', 'on']

        # Disable what is not used or needed to avoid issues with Windows and Ubuntu host machines
        v.customize ["modifyvm", :id, "--audio", "none"]
        v.customize ["modifyvm", :id, "--usb", "off"]
        v.customize ["modifyvm", :id, "--uart2", "off"]
        v.customize ["modifyvm", :id, "--uart3", "off"]
        v.customize ["modifyvm", :id, "--uart4", "off"]
        v.gui = false
    end

    # Sync local to guest directory
    unless settings['local'].empty?
        options = {
            type: settings.fetch('type', settings['type']),
            rsync__args: ['--verbose', '--archive', '--delete', '-z', '--copy-links', '--chmod=ugo=rwX'],
            id: settings['id'],
            create: settings.fetch('create', false),
            mount_options: settings.fetch('mount_options', []),
            nfs_udp: settings.fetch('nfs_udp', false)
        }
        config.vm.synced_folder settings['local'], settings['destination'], options
    end

    # Create env variables on guest
    envvar = ""
    settings.each do |key,setting|
        unless setting.kind_of?(Array)
            showkey = key.upcase
            showsetting = setting.to_s
            envvar += "export CONFIG_#{showkey}=\"#{showsetting}\"\n"
        end
    end
    config.vm.provision "shell", inline:"echo \"#{envvar}\" > /etc/profile.d/docker.sh"

    # Run shell script to configure basic packages
    config.vm.provision 'shell' do |s|
        s.name = 'Configure basic packages'
        s.path = 'provision/base-packages.sh'
    end

    # Run build commands
    builds = "cd #{settings['destination']}\n"
    settings['build_commands'].each do |command|
        builds += "#{command}\n"
    end
    config.vm.provision "shell", inline:"echo \"#{builds}\" > #{settings['destination']}/provision/temp-builds.sh", run: "always"
    config.vm.provision "shell", path: "provision/temp-builds.sh"
end