# frozen_string_literal: true

require_relative 'lib/legion/extensions/identity/system/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-identity-system'
  spec.version       = Legion::Extensions::Identity::System::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Identity System'
  spec.description   = 'LegionIO identity fallback provider — resolves a minimal identity from ENV[\'USER\'] when no other provider succeeds'
  spec.homepage      = 'https://github.com/LegionIO/lex-identity-system'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']        = spec.homepage
  spec.metadata['source_code_uri']     = 'https://github.com/LegionIO/lex-identity-system'
  spec.metadata['documentation_uri']   = 'https://github.com/LegionIO/lex-identity-system'
  spec.metadata['changelog_uri']       = 'https://github.com/LegionIO/lex-identity-system'
  spec.metadata['bug_tracker_uri']     = 'https://github.com/LegionIO/lex-identity-system/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'legion-json',     '>= 1.2.1'
  spec.add_dependency 'legion-settings', '>= 1.3.14'
end
