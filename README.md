# capish

Capish is a simple cookbook for deploying code from git repositories a la
Capistrano. A repo is set up to track a remote branch, and deploys a new
clone when a new commit is detected.

Rollback support is not currently planned; to roll back to an earlier version
of the code, simply push a new commit that rolls your server back. It is
recommended you track a separate branch, e.g. `deploy`, so your commit
history isn't polluted with rollbacks, etc.

If automatically tracking a branch isn't your thing, you can use revisions
or tags instead. Triggering a code deployment is as simple as updating your
cookbook recipe to use the new revision/tag.
