# Unstage a first-time checkout. Tests that a follow-up checkout will do
# nothing.

# Fudge timestamps since they're captured by default at resource definiton
ts = Time.now

capish_repo '/var/www/unstage' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/unstage'
  branch 'deploy'
  timestamp ts
  action :checkout
  notifies :run, 'ruby_block[ustage failed build stub]'
end

ruby_block 'ustage failed build stub' do
  block do
    # Project build...
    sleep(3)
    # Build failed, unstage
    resources(capish_repo: '/var/www/unstage').run_action(:unstage)
  end
  action :nothing
  # Do another checkout (should do nothing, as we don't re-attempt unstaged
  # checkouts)
  notifies :checkout, 'capish_repo[update /var/www/unstage]'
end

# Second checkout
capish_repo 'update /var/www/unstage' do
  repository 'https://github.com/paulholden2/capish-test'
  destination '/var/www/unstage'
  branch 'deploy'
  timestamp ts + 1
  action :nothing
end
