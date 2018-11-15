class Chef
  module Capish
    module Helpers
      require 'git'

      def clone_repo
        ::Git.clone(new_resource.repository, 'repo.git', bare: true, path: new_resource.destination)
      end

      # Check if the HEAD revision matches the remote branch
      def up_to_date?
        repo = ::Git.bare("#{new_resource.destination}/repo.git")
        head = repo.object('HEAD')
        remote = ::Git.ls_remote("#{new_resource.destination}/repo.git")
        branch = remote['branches'][new_resource.branch]
        branch[:sha] == head.sha
      end
    end
  end
end
