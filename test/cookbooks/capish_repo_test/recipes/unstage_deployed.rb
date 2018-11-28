# Deploy a repository, then unstage a follow-up checkout. Ensure
# the latest successful deployment is retained after unstaging a new checkout
# due to failed tasks, tests, etc.

# Fudge timestamps since they're captured by default at resource definiton
ts = Time.now

# Checkout at tag and deploy after a short build stub
capish_repo '/var/www/unstage_deployed' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/unstage_deployed'
  tag 'v0.1.0'
  timestamp ts
  action :checkout
  # Trigger build stub
  notifies :run, 'ruby_block[unstage_deployed build stub]'
end

# Build stub then deploy
ruby_block 'unstage_deployed build stub' do
  block do
    # Project build...
    sleep(3)
    resources(capish_repo: '/var/www/unstage_deployed').run_action(:deploy)
  end
  action :nothing
  # Trigger follow-up checkout
  notifies :checkout, 'capish_repo[update /var/www/unstage_deployed]'
end

# Follow-up checkout at different tag
capish_repo 'update /var/www/unstage_deployed' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/unstage_deployed'
  tag 'v0.1.1'
  timestamp ts + 1
  action :nothing
  # Trigger build stub
  notifies :run, 'ruby_block[unstage_deployed failed build stub]'
end

# Unstage after a failed build stub
ruby_block 'unstage_deployed failed build stub' do
  block do
    # Project build...
    sleep(3)
  end
  action :nothing
  # Try another check out after unstaging. Should do nothing
  notifies :unstage, 'capish_repo[update /var/www/unstage_deployed]'
end
