# Check out a repo but don't deploy it

capish_repo '/var/www/no_deploy' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/no_deploy'
  branch 'deploy'
  action :checkout
end
