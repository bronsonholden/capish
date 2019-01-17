# # encoding: utf-8

# Inspec test for recipe capish::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('git-core') do
  it { should be_installed }
end

describe user('capish') do
  it { should exist }
end
