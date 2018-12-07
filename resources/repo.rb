# Cookbook:: capish
# Resource:: repo

property :repository, String, required: true
property :destination, String, required: true
property :branch, String
property :tag, String
property :user, String, default: 'root'
property :group, String, default: 'root'
property :mode, String, default: '0755'
property :timestamp_format, String, default: '%Y%m%d.%H%M%S%L'
property :timestamp, Time, default: Time.now
property :deploy_key, String, sensitive: true
property :checkout_alias, String, default: 'next'

default_action :checkout

action :clone do
  directory new_resource.destination do
    user new_resource.user
    group new_resource.group
    mode new_resource.mode
    action :create
    recursive true
  end

  ssh_wrapper = %(
    #!/bin/sh
    exec /usr/bin/ssh -o StrictHostKeyChecking=no -i #{deploy_key_path} "$@"
  )

  file ssh_path do
    atomic_update true
    only_if { deploy_key? }
    mode '0750'
    content ssh_wrapper
  end

  file ssh_path do
    action :delete
    only_if { !deploy_key? && ::File.exist?(ssh_path) }
  end

  file deploy_key_path do
    atomic_update true
    only_if { deploy_key? }
    mode '0600'
    sensitive true
    content new_resource.deploy_key
  end

  file deploy_key_path do
    action :delete
    only_if { !deploy_key? && ::File.exist?(deploy_key_path) }
  end

  ruby_block "clone repo #{new_resource.repository}" do
    not_if { repo_cloned? }
    block do
      ::Git.config.git_ssh = ssh_path if deploy_key?
      ::Git.clone(new_resource.repository, 'repo', path: new_resource.destination, bare: true)
    end
  end
end

action :checkout do
  already_cloned = repo_cloned?
  action_clone

  # Resource name
  name = "checkout repo #{new_resource.repository}"

  directory checkout_path do
    # New clones should always do a checkout
    not_if { already_cloned && up_to_date? }
    user new_resource.user
    group new_resource.group
    mode new_resource.mode
    recursive true
    notifies :run, "ruby_block[#{name}]"
    notifies :create, "link[#{checkout_alias_path}]"
  end

  link checkout_alias_path do
    to checkout_path
    action :nothing
  end

  ruby_block name do
    action :nothing
    block do
      ::Git.config.git_ssh = ssh_path if deploy_key?
      repo = ::Git.bare(repo_path)
      repo.with_working checkout_path do
        repo.checkout(new_resource.branch || new_resource.tag)
        repo.checkout_index(all: true)
        repo.fetch('origin', ref: new_resource.branch || new_resource.tag)
        repo.merge('FETCH_HEAD')
      end
    end
  end
end

action :deploy do
  link current_path do
    only_if { checkout? }
    to checkout_path
  end

  link checkout_alias_path do
    only_if { ::File.exist?(checkout_alias_path) }
    action :delete
  end
end

action :unstage do
  link checkout_alias_path do
    only_if { ::File.exist?(checkout_alias_path) }
    action :delete
  end

  directory checkout_path do
    only_if { ::Dir.exist?(checkout_path) }
    recursive true
    action :delete
  end
end

action_class do
  include Chef::Capish::Helpers
end
