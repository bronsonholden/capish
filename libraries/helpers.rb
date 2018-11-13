class Chef
  module Capish
    module Helpers
      require 'git'

      def clone_repo
        ::Git::Base.clone(new_resource.repository, 'repo', bare: true, path: new_resource.destination)
      end
    end
  end
end
