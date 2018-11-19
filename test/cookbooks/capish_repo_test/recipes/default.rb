capish_repo 'capish test repo' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/capish-test'
  branch 'deploy'
  action :checkout
  notifies :run, 'ruby_block[build stub]'
end

ruby_block 'build stub' do
  block do
    # Project build...
    sleep(3)
  end
  action :nothing
  notifies :deploy, 'capish_repo[capish test repo]'
end
