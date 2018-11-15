# # encoding: utf-8

# Inspec test for resource capish_repo

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/var/www/capish-test') do
  it { should exist }
end
