property :repository, String, required: true
property :destination, String, required: true
property :branch, String
property :tag, String
property :user, String, default: 'root'
property :group, String, default: 'root'
property :mode, String, default: '0640'
property :timestamp_format, String, default: '%Y%m%d.%H%M%S%L'

default_action :checkout

action :checkout do
  # Deployment timestamp
  ts = Time.now.strftime('%Y%m%d.%H%M%S%L')
  # Resource name
  name = "checkout repo #{new_resource.repository}"
  # The canonical path of the new checkout
  checkout_path = "#{new_resource.destination}/#{ts}"

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
      repo = ::Git.clone(new_resource.repository, ts, path: new_resource.destination)
      if !new_resource.branch.nil?
        repo.checkout(new_resource.branch)
      elsif !new_resource.tag.nil?
        repo.checkout(new_resource.tag)
      end
    end
  end
end

action_class do
  include Chef::Capish::Helpers
end
