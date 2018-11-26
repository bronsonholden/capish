capish_repo '/var/www/nodeploy' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/nodeploy'
  branch 'deploy'
  action :checkout
end
