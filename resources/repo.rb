property :repository, String, required: true
property :destination, String, required: true
property :branch, String
property :tag, String
property :user, String, default: 'root'
property :group, String, default: 'root'
property :mode, String, default: '0755'
property :timestamp_format, String, default: '%Y%m%d.%H%M%S%L'

default_action :checkout

action :clone do
  ruby_block "clone repo #{new_resource.repository}" do
    not_if { repo_cloned? }
    block do
      repo = ::Git.clone(new_resource.repository, 'repo', path: new_resource.destination, bare: true)
    end
  end
end

action :checkout do
  action_clone

  # Deployment timestamp
  ts = Time.now.strftime(new_resource.timestamp_format)
  # Resource name
  name = "checkout repo #{new_resource.repository}"
  # The canonical path of the new checkout
  checkout_path = "#{new_resource.destination}/releases/#{ts}"

  directory checkout_path do
    not_if { up_to_date? }
    user new_resource.user
    group new_resource.group
    mode new_resource.mode
    recursive true
    notifies :create, "link[#{current_path}]"
    notifies :run, "ruby_block[#{name}]"
  end

  link current_path do
    action :nothing
    to checkout_path
  end

  ruby_block name do
    action :nothing
    block do
      repo = ::Git.bare("#{new_resource.destination}/repo")
      repo.with_working checkout_path do
        repo.checkout(new_resource.branch)
        repo.checkout_index(all: true)
        repo.fetch('origin', ref: new_resource.branch || new_resource.tag)
        repo.merge('FETCH_HEAD')
      end
    end
  end
end

action_class do
  include Chef::Capish::Helpers
end
