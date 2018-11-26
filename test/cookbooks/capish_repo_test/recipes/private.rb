capish_repo '/var/www/private' do
  repository 'git@github.com:paulholden2/capish-test-private'
  destination '/var/www/private'
  branch 'deploy'
  action :checkout
  # This key only has read access to the private testing repo
  deploy_key <<~EOF
  -----BEGIN RSA PRIVATE KEY-----
  MIIEowIBAAKCAQEArwtYLP9Di5+VCk33bgfVry9UrQoFRthwYcPoiI6WjFKLMriS
  1Zg3O2q2rPzfIYcnUmFFaL3xgY1oqk9gu9VRH0eE+/17p44amx0Gixh5FpHgm6/3
  ZghSndPlcZvvBszejSm15XKplbtQsMER6Ea7rgWvCkyBYWxklC0OEE1WHtquhSA7
  KbM6rcS0sDbvdxNISfI4T457d/nlomVKLr64ZfG8HlVp2RN+J3h7dxlvuGFrYLco
  RLsWPLlbqJIMrB4Qe8BpARQcU1YqiGGlW8eA53rH+blU6XsUO/BBc7Ui1IgBGgWx
  a5fPGpeuQyhnKWV9bYDZ+SSbKTe1Fe4J6A3JuQIDAQABAoIBAH9TWi1I9KIAT5Iy
  SlPQASAv5oED8/ingX+r2F5Uka+6byRS3APgd/SRWBWWztt9ix3CQZHB8IUTDlor
  6SpYLWz6QgJmTOcBV9sSjurov1Oqgt3cbrHaRfYl5xTvnzusFApMl9IxyKdwnG4l
  0lfJ88TOv5dXNRlflf2ulDdJeeZwaM+t+tX0aeSnefP9IxApW61nr6eiSKpXWLYu
  FOE0yIffUG6O8rUZgX5QMR+yn89suMWNBX8PH2WEJCL7J2vCESyk/j+hT4vKYn6k
  5fsJYhPWO61UKSrl9QHpOsLIP0dctm2DflcaXY+gBzMYUSJlJh778r7c8EBBOEUf
  r0nia+0CgYEA4PN9ATGEQTDe/KMNxSgZnlDtNrz2Ds24MBpnBk4U8pQYn6uYk4yS
  0yat4yWEdCJWnGsgWmut4qxiUb+wREBQGxTe9cmCc13klo065LFhoLqKAm0DTG6g
  aDUPre6fa94bdrlJmwBA6d0agnInHFi9zoN55091pPiFaBFKqplS94cCgYEAxzRt
  3w8G2CTxdG73eZ5WmxlFSrI1sryXHDSbVgmxX3YYPanHkLI5AXEdbVTPjrpLDkWW
  1KghsmGz6stgeR2G15lhbS18eU236iUS7vTinjqh+QvZm46YGq3oqlqIIs7QWeJg
  LwsmqwRlVCPhMZUSX9wPHKnpIsRIE57Fr26vBL8CgYEAkgsCeSfgqUJFQtfJNNrX
  5wS7PPJo/StqDTDW+izvRJ4JboBFSmXVXOibtADDgXJZsKuMEage+C7aliBRG751
  Q1/FcOUmoCexJF0Egzz2GReCShjkL1cTJRRt3YoyTiGgyu94bf04J5y4fUAHTEwA
  znZlSls4EaaXVf0D8MYiKzkCgYAjB/hOYrEcb5q6lA0XKR4n1lDWKvLAhOO6BRJQ
  FhJILFdk+KdsrbrSoxa+tExv2Bj84IX+zbZnTUE7iBpmEig1X/a/IWGjX2R5W52x
  wgTcOIllZ40UCwZ6opyo4JTSMjZ3qBSsETTynCpJmqmuc32wt908eDDUeVoHgUNY
  b4l9twKBgC5POVlkY72kzkKocBUyAG2Y/0UVx5/jEGqkGGbNXY3sVMOZee1JI5jx
  wALe+SglcqKb58erIPe02g6lqzuSL3cjP61LxiIqMLRN2vQzL9nDn9oPWvI8+eFH
  S9g0jj3U/e6BXrtNBIa1nbkIAQbBM5RW3yq+kB9VzwZTU9VXWkM9
  -----END RSA PRIVATE KEY-----
  EOF
  notifies :run, 'ruby_block[build stub]'
end

ruby_block 'build stub' do
  block do
    # Project build...
    sleep(3)
  end
  action :nothing
  notifies :deploy, 'capish_repo[/var/www/private]'
end
