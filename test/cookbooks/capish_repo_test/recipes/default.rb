capish_repo '/var/www/default' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/default'
  branch 'deploy'
  action :checkout
  notifies :run, 'ruby_block[default build stub]'
end

ruby_block 'default build stub' do
  block do
    # Project build...
    sleep(3)
  end
  action :nothing
  notifies :deploy, 'capish_repo[/var/www/default]'
end
