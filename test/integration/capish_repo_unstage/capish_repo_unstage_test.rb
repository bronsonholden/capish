# # encoding: utf-8

# Inspec test for resource capish_repo: unstage instead of deploy

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/var/www/unstage') do
  it { should exist }
  it { should be_directory }
end

describe directory('/var/www/unstage/releases') do
  it { should exist }
  it { should be_directory }
end

# No support for be_empty on directory resources, so we'll make do with
# ensuring output of ls is empty
describe command('ls /var/www/unstage/releases') do
  its(:stdout) { should be_empty }
end

describe file('/var/www/unstage/current') do
  it { should_not exist }
end

describe file('/var/www/unstage/next') do
  it { should_not exist }
end
