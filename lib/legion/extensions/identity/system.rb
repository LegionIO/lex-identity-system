# frozen_string_literal: true

require 'legion/extensions/identity/system/version'
require 'legion/extensions/identity/system/identity'

module Legion
  module Extensions
    module Identity
      module System
        extend Legion::Extensions::Core if Legion::Extensions.const_defined?(:Core, false)

        def self.identity_provider?
          true
        end

        def self.remote_invocable?
          false
        end
      end
    end
  end
end
