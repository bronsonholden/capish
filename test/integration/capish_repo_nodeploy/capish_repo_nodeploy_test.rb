# # encoding: utf-8

# Inspec test for resource capish_repo: pre-deploy state test

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/var/www/nodeploy') do
  it { should exist }
  it { should be_directory }
end

describe directory('/var/www/nodeploy/releases') do
  it { should exist }
  it { should be_directory }
end

describe file('/var/www/nodeploy/current') do
  it { should_not exist }
end

describe file('/var/www/nodeploy/next') do
  it { should exist }
  it { should be_symlink }
  its(:mode) { should cmp '0755' }
end
