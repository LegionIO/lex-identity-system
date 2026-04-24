# frozen_string_literal: true

require 'socket'

module Legion
  module Extensions
    module Identity
      module System
        module Identity
          module_function

          def provider_name
            :system
          end

          def provider_type
            :fallback
          end

          def facing
            nil
          end

          def priority
            0
          end

          def trust_weight
            200
          end

          def trust_level
            :unverified
          end

          def capabilities
            [:profile]
          end

          def resolve
            raw = ENV.fetch('USER', nil)
            return nil if raw.nil? || raw.strip.empty?

            normalized = normalize(raw)
            return nil if normalized.empty?

            {
              canonical_name: normalized,
              kind:           :human,
              source:         :system,
              persistent:     false,
              groups:         [],
              profile:        {
                username: raw,
                hostname: ::Socket.gethostname
              }
            }
          end

          def normalize(val)
            str = val.to_s.downcase.strip
            str = str.split('@', 2).first if str.include?('@')
            str.gsub('.', '-').gsub(/[^a-z0-9_-]/, '')
          end
        end
      end
    end
  end
end
