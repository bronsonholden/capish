# # encoding: utf-8

# Inspec test for resource capish_repo: private repositories

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/var/www/private') do
  it { should exist }
  it { should be_directory }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

describe directory('/var/www/private/releases') do
  it { should exist }
  it { should be_directory }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

describe directory('/var/www/private/repo') do
  it { should exist }
  it { should be_directory }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

describe file('/var/www/private/current') do
  it { should exist }
  it { should be_symlink }
  its(:mode) { should cmp '0755' }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

describe file('/var/www/private/deploy_key') do
  it { should exist }
  its(:mode) { should cmp '0600' }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

describe file('/var/www/private/ssh') do
  it { should exist }
  its(:mode) { should cmp '0750' }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

describe file('/var/www/private/current/test.txt') do
  it { should exist }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end
