# Stage a checkout, then without deploying, stage the next. Tests to ensure
# failed builds do not take down the last successful build, and can be
# replaced with a following deployment.

# Fudge timestamps since they're captured by default at resource definiton
ts = Time.now

# Checkout at tag and deploy after a short build stub
capish_repo '/var/www/failed_deploy_followup' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/failed_deploy_followup'
  tag 'v0.1.0'
  timestamp ts
  action :checkout
  # Trigger build stub
  notifies :run, 'ruby_block[failed_deploy_followup build stub]'
end

# Build stub then deploy
ruby_block 'failed_deploy_followup build stub' do
  block do
    # Project build...
    sleep(3)
    resources(capish_repo: '/var/www/failed_deploy_followup').run_action(:deploy)
  end
  action :nothing
  # Trigger follow-up checkout
  notifies :checkout, 'capish_repo[update /var/www/failed_deploy_followup]'
end

# Follow-up checkout at different tag
capish_repo 'update /var/www/failed_deploy_followup' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/failed_deploy_followup'
  tag 'v0.1.1'
  timestamp ts + 1
  action :nothing
  # Trigger build stub
  notifies :run, 'ruby_block[failed_deploy_followup failed build stub]'
end

# Unstage after a failed build stub
ruby_block 'failed_deploy_followup failed build stub' do
  block do
    # Project build...
    sleep(3)
  end
  action :nothing
  # Unstage after failed build stub
  notifies :deploy, 'capish_repo[update /var/www/failed_deploy_followup]'
end
