property :repository, String, required: true
property :destination, String, required: true
property :branch, String, default: 'deploy'
property :user, String, default: 'root'
property :group, String, default: 'root'
property :mode, String, default: '0640'
property :timestamp_format, String, default: '%Y%m%d.%H%M%S%L'

default_action :deploy
action :deploy do
  # Deployment timestamp
  # ts = Time.now.strftime(new_resource.timestamp_format)

  directory new_resource.destination do
    user new_resource.user
    group new_resource.group
    mode new_resource.mode
    recursive true
    notifies :run, 'ruby_block[clone git repo]'
  end

  ruby_block 'clone git repo' do
    action :nothing
    block do
      clone_repo
    end
  end
end

action_class do
  include Chef::Capish::Helpers
end
