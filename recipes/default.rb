# Cookbook:: capish
# Recipe:: default

apt_update
package 'git-core'

user 'capish' do
  password 'capish'
  action :create
end
