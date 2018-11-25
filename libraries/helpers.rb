class Chef
  module Capish
    module Helpers
      require 'git'

      def current_path
        "#{new_resource.destination}/current"
      end

      # Path to the SSH wrapper script
      def ssh_path
        "#{new_resource.destination}/ssh"
      end

      def repo_path
        "#{new_resource.destination}/repo"
      end

      def deploy_key_path
        "#{new_resource.destination}/deploy_key"
      end

      # Get the canonical path of the new checkout
      def checkout_path
        ts = new_resource.timestamp.strftime(new_resource.timestamp_format)
        "#{new_resource.destination}/releases/#{ts}"
      end

      def checkout_alias_path
        "#{new_resource.destination}/#{new_resource.checkout_alias}"
      end

      def deploy_key?
        !new_resource.deploy_key.nil?
      end

      # Check if we have a checkout directory to deploy
      def checkout?
        ::File.exist?(checkout_path)
      end

      def repo_cloned?
        # TODO: Check if it's actually a repo
        File.directory?(repo_path)
      end

      # Check if the repository exists
      def repo_exists?
        ::Git.config.git_ssh = ssh_path if deploy_key?
        ::Git.open(current_path)
        true
      rescue
        false
      end

      # Get the hash of the current checkout HEAD
      def current_head_sha
        ::Git.config.git_ssh = ssh_path if deploy_key?
        current = ::Git.bare(repo_path)
        current_head = current.object('HEAD')
        current_head.sha
      end

      # Get the hash of the remote HEAD
      def remote_head_sha
        ::Git.config.git_ssh = ssh_path if deploy_key?
        remote = ::Git.ls_remote(new_resource.repository)
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
