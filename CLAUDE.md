# lex-identity-system: System ENV Identity Fallback for LegionIO

**Repository Level 3 Documentation**
- **Parent (Level 2)**: `/Users/miverso2/rubymine/legion/extensions/CLAUDE.md`
- **Parent (Level 1)**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Identity fallback provider. Reads `ENV['USER']` to produce a minimal identity when no other provider resolves. `provider_type: :fallback` — distinct from `:auth` and `:profile` providers. Last resort in the identity resolution chain.

**GitHub**: https://github.com/LegionIO/lex-identity-system
**License**: MIT
**Version**: 0.1.0

## Architecture

```
Legion::Extensions::Identity::System
└── Identity    # provider contract: resolve, normalize, provider_name, provider_type, ...
```

No runners, no actors, no transport, no helpers. Strictly minimal.

## File Map

| File | Purpose |
|------|---------|
| `lib/legion/extensions/identity/system.rb` | Entry point, extends Core, declares `identity_provider?` and `remote_invocable?` |
| `lib/legion/extensions/identity/system/identity.rb` | Provider contract: all methods including `resolve` and `normalize` |
| `lib/legion/extensions/identity/system/version.rb` | `VERSION = '0.1.0'` |

## Provider Contract

| Method | Return |
|--------|--------|
| `provider_name` | `:system` |
| `provider_type` | `:fallback` |
| `facing` | `nil` |
| `priority` | `0` |
| `trust_weight` | `200` |
| `capabilities` | `[:profile]` |
| `resolve` | identity hash or `nil` |
| `normalize(val)` | String |

## Key Rules

- `persistent: false` in the resolved hash — signals no durable principal should be created
- `normalize` removes dots (AMQP word separator) — result must match `^[a-z0-9][a-z0-9_-]*$`
- Returns `nil` when `ENV['USER']` is nil, empty, or normalizes to empty string
- No `provide_token`, no `vault_auth`, no group support

## Dependencies

| Gem | Purpose |
|-----|---------|
| `legion-json` | JSON serialization (framework compat) |
| `legion-settings` | Configuration management (framework compat) |

## Testing

```bash
bundle install
bundle exec rspec     # ~30 specs
bundle exec rubocop   # Clean
```

---

**Maintained By**: Matthew Iverson (@Esity)
