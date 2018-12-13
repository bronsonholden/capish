# capish

[![Build Status](https://travis-ci.org/paulholden2/capish.svg?branch=master)](https://travis-ci.org/paulholden2/capish)

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

Capish uses the [git](https://rubygems.org/gems/git) gem to interact with local and remote repositories.

## Example

```rb
capish_repo 'my repo' do
  repository 'https://github.com/paulholden2/capish'
  deploy_key '<your SSH private key here>'
  checkout_alias 'staging'
  destination '/var/www/capish'
  branch 'deploy'
  action :checkout, :deploy # See "About :deploy" below
end
```

## capish_repo

#### Properties

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| repository | String | Yes | | Your remote repository's URL. |
| deploy_key | String | No | | The deploy SSH key to use when accessing the repository. |
| destination | String | Yes | | The target directory for deployment. |
| checkout_alias | String | No | next | The alias for checkouts, used as the working directory for tasks before the `:deploy` action is executed. |
| branch | String | No | | Which branch to check out. If not defined, you must define a tag. |
| tag | String | No | | Which tag to check out. If not defined, you must define a branch. |
| user | String | No | root | The owner of the checkout directories. |
| group | String | No | root | The group of the checkout directories. |
| mode | String | No | 0755 | The mode to assign to checkout directories. |
| timestamp_format | String | No | %Y%m%d.%H%M%S%L | What format to use when creating checkout directories. |
| timestamp | Time | No | `Time.now` | The timestamp for the deployment. Default is the time of resource definition. |

#### Actions

| Action | Default | Description |
|--------|---------|-------------|
| checkout | Yes | Runs the clone action, then checks out the most recent revision in your branch, or at your tag. |
| clone | No | Clones the repo if it doesn't already exist. |
| deploy | No | Create the `current` symlink in the destination directory, to the checkout. Does nothing if no checkout was created. |
| unstage | No | Removes the checkout directory and checkout alias symlink. This action does not roll back the local repo to the previous revision. You will have to push a new commit to your branch or update your tag with fixes to trigger another checkout. Execute this action if e.g. your build task fails. |

## About `:deploy`

You will have to notify your capish_repo resource with the
`:deploy` action before your code is actually deployed. This is not done
automatically both to prevent deploying code that needs build tasks to run,
and to avoid deploying a failed build. Typically you will do something
like:

```rb
capish_repo 'my repo' do
  # Repo configuration
  ...
  notifies :build, 'other[resource]'
end

other 'resource' do
  # Doing my build here
  ...
  notifies :deploy, 'capish_repo[my repo]'
end
```

## License

Capish is licensed under the ISC license. See the LICENSE file for details.
