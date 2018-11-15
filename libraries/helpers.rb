class Chef
  module Capish
    module Helpers
      require 'git'

      def repo_path
        "#{new_resource.destination}/repo.git"
      end

      def repo_exists?
        begin
          repo = ::Git.bare(repo_path)
          true
        rescue
          false
        end
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
