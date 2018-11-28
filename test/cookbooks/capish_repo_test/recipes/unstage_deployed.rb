# Deploy a repository, then unstage a follow-up checkout. Ensure
# the latest successful deployment is retained after unstaging a new checkout
# due to failed tasks, tests, etc.

ts = Time.now

capish_repo '/var/www/unstage_deployed' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/unstage_deployed'
  tag 'v0.1.0'
  timestamp ts
  action :checkout
  notifies :run, 'ruby_block[unstage_deployed build stub]'
end

ruby_block 'unstage_deployed build stub' do
  block do
    # Project build...
    sleep(3)
    resources(capish_repo: '/var/www/unstage_deployed').run_action(:deploy)
  end
  action :nothing
  notifies :checkout, 'capish_repo[update /var/www/unstage_deployed]'
end

capish_repo 'update /var/www/unstage_deployed' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/unstage_deployed'
  tag 'v0.1.1'
  timestamp ts + 1
  action :nothing
  notifies :run, 'ruby_block[unstage_deployed failed build stub]'
end

ruby_block 'unstage_deployed failed build stub' do
  block do
    # Project build...
    sleep(3)
  end
  action :nothing
  # Try another check out after unstaging. Should do nothing
  notifies :unstage, 'capish_repo[update /var/www/unstage_deployed]'
end
