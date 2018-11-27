capish_repo '/var/www/unstage' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/unstage'
  branch 'deploy'
  action :checkout
  notifies :run, 'ruby_block[failed build stub]'
end

ruby_block 'failed build stub' do
  block do
    # Project build...
    sleep(3)
    # Build failed, unstage
    resources(capish_repo: '/var/www/unstage').run_action(:unstage)
  end
  action :nothing
end
