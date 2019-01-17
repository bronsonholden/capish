# # encoding: utf-8

# Inspec test for resource capish_repo: pre-deploy state test

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/var/www/no_deploy') do
  it { should exist }
  it { should be_directory }
  its(:user) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

describe directory('/var/www/no_deploy/releases') do
  it { should exist }
  it { should be_directory }
  its(:user) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

describe file('/var/www/no_deploy/current') do
  it { should_not exist }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

describe file('/var/www/no_deploy/next') do
  it { should exist }
  it { should be_symlink }
  its(:mode) { should cmp '0755' }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end
