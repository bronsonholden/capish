class Chef
  module Capish
    module Helpers
      require 'git'

      def current_path
        "#{new_resource.destination}/current"
      end

      # Check if the repository exists
      def repo_exists?
        begin
          repo = ::Git.open(current_path)
          true
        rescue
          false
        end
      end

      def current_head_sha
        current = ::Git.bare("#{current_path}/.git")
        current_head = current.object('HEAD')
        current_head.sha
      end

      def remote_head_sha
        remote = ::Git.ls_remote("#{new_resource.repository}.git")
        if not new_resource.branch.nil? then
          branch = remote['branches'][new_resource.branch]
          branch[:sha]
        elsif not new_resource.tag.nil? then
          tag = remote['tags'][new_resource.tag]
          tag[:sha]
        end
      end

      # Check if the HEAD revision matches the remote branch
      def up_to_date?
        unless ::File.symlink?(current_path) then
          return false
        end

        current_head_sha == remote_head_sha
      end
    end
  end
end
