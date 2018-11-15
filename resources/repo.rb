property :repository, String, required: true
property :destination, String, required: true
property :branch, String, default: 'deploy'
property :user, String, default: 'root'
property :group, String, default: 'root'
property :mode, String, default: '0640'
property :timestamp_format, String, default: '%Y%m%d.%H%M%S%L'

default_action :deploy

action :deploy do
  action_clone
end

action :clone do
  directory new_resource.destination do
    user new_resource.user
    group new_resource.group
    mode new_resource.mode
    recursive true
  end

  ruby_block "clone repo #{new_resource.repository}" do
    not_if { repo_exists? }
    block do
      ::Git.clone(new_resource.repository, 'repo.git', bare: true, path: new_resource.destination)
    end
  end
end

action_class do
  include Chef::Capish::Helpers
end
