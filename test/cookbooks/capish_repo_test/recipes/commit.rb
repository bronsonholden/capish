# Check out and deploy a repo by revision, after a short build stub

capish_repo '/var/www/commit' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/commit'
  commit '54ffeae'
  action :checkout
  notifies :run, 'ruby_block[commit build stub]'
end

ruby_block 'commit build stub' do
  block do
    # Project build...
    sleep(3)
  end
  action :nothing
  notifies :deploy, 'capish_repo[/var/www/commit]'
end
