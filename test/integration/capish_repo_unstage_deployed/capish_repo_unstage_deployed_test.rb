# # encoding: utf-8

# Inspec test for resource capish_repo: unstage on already deployed repo

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/var/www/unstage_deployed') do
  it { should exist }
  it { should be_directory }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

describe directory('/var/www/unstage_deployed/releases') do
  it { should exist }
  it { should be_directory }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

# Current symlink should exist from first successful deploy
describe file('/var/www/unstage_deployed/current') do
  it { should exist }
  its(:owner) { should eq 'capish' }
  its(:group) { should eq 'capish' }
end

# Next symlink should be destroyed since we unstaged
describe file('/var/www/unstage_deployed/next') do
  it { should_not exist }
end
