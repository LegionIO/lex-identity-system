# Changelog

## [Unreleased]

## [0.2.0] - 2026-04-24

### Added
- `trust_level` method returning `:unverified` on provider contract
- Self-registration with `Legion::Identity::Resolver` at load time

### Fixed
- `normalize` now strips `@domain` and converts dots to hyphens (`matt.iverson@optum.com` → `matt-iverson` instead of `mattiversonoptumcom`)

## [0.1.1] - 2026-04-09

### Changed
- Updated documentation (CLAUDE.md)

## [0.1.0] - 2026-04-06

### Added

- Initial release
- `Identity` module implementing the LegionIO identity provider contract
- `provider_type: :fallback` — last resort when no other provider resolves
- `resolve` reads `ENV['USER']` and returns a minimal identity hash with `persistent: false`
- `normalize` strips non-alphanumeric characters (except `_` and `-`) for AMQP-safe names
- `trust_weight: 200` (least trusted), `priority: 0` (lowest), `capabilities: [:profile]`
- No actors, no auth, no group resolution — strictly minimal ENV-based fallback
