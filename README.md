# lex-identity-system

LegionIO identity fallback provider. Reads `ENV['USER']` to produce a minimal identity when no other provider resolves. It is the last resort in the identity resolution chain.

## Provider contract

| Attribute | Value |
|-----------|-------|
| `provider_name` | `:system` |
| `provider_type` | `:fallback` |
| `facing` | `nil` |
| `priority` | `0` (lowest) |
| `trust_weight` | `200` (least trusted) |
| `capabilities` | `[:profile]` |

## Behavior

`Identity.resolve` reads `ENV['USER']`. If present and non-empty after normalization, it returns:

```ruby
{
  canonical_name: "jsmith",       # normalized: downcase, strip, remove non-alnum except _ and -
  kind: :human,
  source: :system,
  persistent: false,              # ephemeral — no durable principal should be created
  groups: [],
  profile: {
    username: "jsmith",           # original ENV['USER'] value
    hostname: "my-host.example"   # Socket.gethostname
  }
}
```

Returns `nil` if `ENV['USER']` is nil, empty, or normalizes to an empty string.

`persistent: false` signals to callers that no durable principal should be created from this identity.

## What this provider does NOT do

- No token issuance (`provide_token`)
- No Vault authentication (`vault_auth`)
- No group resolution
- No actors (nothing to refresh)
- No remote calls of any kind (`remote_invocable? => false`)

## Normalization

`normalize(val)` applies `val.to_s.downcase.strip.gsub(/[^a-z0-9_-]/, '')`. Dots are stripped because `.` is an AMQP word separator.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-identity-system'
```

## License

MIT
