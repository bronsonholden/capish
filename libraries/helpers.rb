class Chef
  module Capish
    module Helpers
      require 'git'

      def current_path
        "#{new_resource.destination}/current"
      end

      def repo_cloned?
        # TODO: Check if it's actually a repo
        File.directory?("#{new_resource.destination}/repo")
      end

      # Check if the repository exists
      def repo_exists?
        ::Git.open(current_path)
        true
      rescue
        false
      end

      # Get the hash of the current checkout HEAD
      def current_head_sha
        current = ::Git.bare("#{new_resource.destination}/repo")
        current_head = current.object('HEAD')
        current_head.sha
      end

      # Get the hash of the remote HEAD
      def remote_head_sha
        remote = ::Git.ls_remote("#{new_resource.repository}")
        if !new_resource.branch.nil?
          branch = remote['branches'][new_resource.branch]
          branch[:sha]
        elsif !new_resource.tag.nil?
          tag = remote['tags'][new_resource.tag]
          tag[:sha]
        end
      end

      # Check if the HEAD revision matches the remote branch
      def up_to_date?
        return false unless File.symlink?(current_path)

        current_head_sha == remote_head_sha
      end
    end
  end
end
