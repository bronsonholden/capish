# capish

Capish is a simple cookbook for deploying code from git repositories a la
Capistrano. A repo is set up to track a remote branch, and deploys a new
clone when a new commit is detected.

Rollbacks are not supported; to roll back to an earlier version
of the code, force push to your tracking branch so it points to the desired
revision, or use tags instead. New checkout directories are created both to
encourage maintaining a stateless app and to abandon any existing cached
files like compiled scripts and stylesheets, etc. so they can be rebuilt
in a fresh directory.

If automatically tracking a branch isn't your thing, you can use revisions
or tags instead. Triggering a code deployment is as simple as updating your
cookbook recipe to use the new revision/tag.

## Example

```rb
capish_repo 'my repo' do
  repository 'https://github.com/paulholden2/capish'
  deploy_key '<your SSH private key here>'
  destination '/var/www/capish'
  branch 'deploy'
end
```

## capish_repo

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| repository | String | true | | Your remote repository's URL. |
| deploy_key | String | | | The deploy SSH key to use when accessing the repository. Not yet supported. |
| destination | String | true | | The target directory for deployment. |
| branch | String | | | Which branch to check out. If not defined, you must define a tag. |
| tag | String | | | Which tag to check out. If not defined, you must define a branch. |
| user | String | | root | The owner of the checkout directories. |
| group | String | | root | The gruop of the checkout directories. |
| mode | String | | 0755 | The mode to assign to checkout directories. |
| timestamp_format | String | | %Y%m%d.%H%M%S%L | What format to use when creating checkout directories. |
| timestamp | Time | | Time.now | The timestamp for the deployment. Default is the moment the `:checkout` action occurs. |
