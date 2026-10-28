# thecore_settings — AI Context

## What this is

A Rails engine gem (Ruby) of the Thecore framework: the key/value **Settings** store every Thecore
app uses for runtime configuration (SMTP, SQL credentials, schedules, …), editable from RailsAdmin.
It is a fork of `rails_admin_settings`, renamed and moved onto ActiveRecord. Host apps get it through
`thecore_auth_commons`, never declared directly. Part of the framework documented at
https://github.com/gabrieletassoni/thecore/tree/release/3.

## Key files

| File | Purpose |
|---|---|
| `app/models/thecore_settings/setting.rb` | `ThecoreSettings::Setting`, one row per `(ns, key)` with a typed `raw` value |
| `lib/thecore_settings/settings.rb`, `namespaced.rb` | The `Settings.ns(:name).key` DSL |
| `lib/thecore_settings/kinds.rb`, `processing.rb`, `validation.rb` | Value types (string, integer, boolean, email, phone, color, file, …), parsing and validation |
| `lib/thecore_settings/rails_admin_config.rb`, `app/views/rails_admin/main/_setting_value.html.erb` | RailsAdmin list/edit configuration |
| `lib/thecore_settings/storage/`, `uploads.rb` | File-typed settings (Shrine, CarrierWave) |
| `db/migrate/` | Creates the table; migrates data from `rails_admin_settings` |

## Conventions

- Read a value with `ThecoreSettings::Setting.find_by(ns:, key:)` when it must always be fresh. The
  `Settings.ns(...)` DSL memoizes a namespace for the life of the process, so a long-running
  process (Sidekiq) doesn't see an admin's later edit.
- Host apps seed their defaults with `find_or_create_by!` in their own `db/seeds.rb`.

## Running tests

There is no runnable suite. `spec/` is the RSpec suite inherited from `rails_admin_settings`: it
targets Mongoid (`ACTIVERECORD` unset), and neither `rspec` nor `mongoid` is in the `Gemfile`.
`bin/test` expects a `test/` directory that doesn't exist. Behaviour is covered indirectly by the
host apps' suites. A new test belongs in a Minitest suite on **PostgreSQL only** (never SQLite),
like every Thecore gem.

## Release

Bump `lib/thecore_settings/version.rb` and push to `release/3`: `.github/workflows/gempush.yml`
tags the version and publishes it to RubyGems.org. A push that doesn't change the version publishes
nothing, and no other branch ever publishes. Then, in each host app,
`bundle update thecore_settings --conservative` and commit `Gemfile.lock` together with the moved
submodule pointer.

## Security scanning

Configured in the GitHub repository settings, not in files:

- **CodeQL** default setup (Ruby, the Actions workflows, and JavaScript/TypeScript where the gem
  ships any): on every push to `release/3`, on pull requests and weekly. Findings: Security → Code
  scanning.
- **Secret scanning with push protection**: a push containing a recognised secret is rejected. It
  is the only check that blocks anything. If it fires on a real secret, remove it from the commit and
  rotate the secret; never bypass it.
- **Dependabot alerts and security updates**, but no `dependabot.yml`, so no routine version-bump
  pull requests. This gem commits no `Gemfile.lock`, so Dependabot only sees the gemspec and the
  workflow Actions: CVEs in the resolved Ruby dependencies are caught by `bundler-audit` in the host
  apps' pipelines, whose `Gemfile.lock` resolves every ATOM.
- Findings never block a release: GitHub notifies the owner. When one needs work, open a GitHub
  issue (see Agent skills).

## Agent skills

### Issue tracker

Tasks, issues, bugs, tickets and specs for this repository live **only** in its GitHub Issues
(`gabrieletassoni/thecore_settings`), handled with the `gh` CLI. See `docs/agents/issue-tracker.md`.

**Mandatory rule.** Whenever a skill or development work creates, reads, updates, comments on,
assigns, blocks or closes a task, issue, bug, ticket or spec (for example /to-tickets, /to-spec,
/triage, /wayfinder, /implement, /diagnosing-bugs, /code-review, closing a piece of work, a bug found
during a session), do it in this repository's GitHub Issues following `docs/agents/issue-tracker.md`.
Never use Odoo, `.scratch/` or local Markdown files as a tracker: Odoo is only for the repositories
on Bancolini's GitLab. `#123` means a GitHub issue number of this repository. If `gh` doesn't work,
stop and say so instead of falling back to another tracker.

### Triage labels

The five canonical triage roles map to GitHub labels with the same name (`needs-triage`,
`needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` and `docs/adr/` at the repo root, created lazily when the first
term or decision is resolved. See `docs/agents/domain.md`.

### Skills

Matt Pocock's skills come from the `mattpocock-skills` Claude Code plugin installed on the
developer's **host** (`claude plugins install mattpocock-skills`, official marketplace), never
vendored here: no `.agents/skills/`, `.claude/commands/` or `skills-lock.json`. Its `ask-matt` skill
maps how the skills connect.
