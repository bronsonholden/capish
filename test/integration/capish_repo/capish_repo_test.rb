# # encoding: utf-8

# Inspec test for resource capish_repo

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/var/www/capish-test') do
  it { should exist }
  it { should be_directory }
end

describe directory('/var/www/capish-test/releases') do
  it { should exist }
  it { should be_directory }
end

describe file('/var/www/capish-test/current') do
  it { should exist }
  it { should be_symlink }
  its(:mode) { should cmp '0755' }
end
