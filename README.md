# varve-sh/homebrew-tap

Homebrew formulae for [varve](https://github.com/varve-sh/varve) — decision
memory for AI coding agents.

```bash
brew install varve-sh/tap/varve
```

Homebrew 6 refuses to load formulae from third-party taps until they are
trusted, so on a first install you will see:

```
Error: Refusing to load formula varve-sh/tap/varve from untrusted tap varve-sh/tap.
```

That is Homebrew policy, not a broken formula. Run `brew trust varve-sh/tap`
and install again.

## Contents

| Formula | Status |
|---|---|
| `varve` | Current. Written by GoReleaser on each release of `varve-sh/varve`. |

`Formula/varve.rb` is generated. Do not hand-edit it; it is overwritten on
every release.

`memtrace` was this project's name until 2026-07-29. Its formula is gone;
`formula_renames.json` maps the old name to `varve`, so anything still asking
for `memtrace` resolves here.

## Coming from memtrace

```bash
brew update
brew upgrade
```

That is the whole migration. `formula_renames.json` makes Homebrew treat
`memtrace` as a former name of `varve`, so the upgrade replaces the old keg
rather than installing a second one — verified on 2026-07-30 against a real
memtrace 1.5.3 install: `brew upgrade memtrace` resolved to
`varve-sh/tap/varve`, installed 2.0.0, and removed
`Cellar/memtrace/1.5.3`.

Two things that trip this up, both one-time:

- **Trust.** On Homebrew 6 the upgrade fails with the "untrusted tap" error
  above until you run `brew trust varve-sh/tap`. A memtrace user meets this
  during the upgrade, not at install time, so it reads as the migration being
  broken when it is not.
- **The old tap name.** Installs from before the rename are tapped as
  `memtrace-dev/tap`. `brew update` follows GitHub's repository redirect and
  renames the local tap directory to `varve-sh/tap` on its own — no `brew
  untap` needed.

Your memory store is not touched by any of this. varve reads a pre-rename
store at `.memtrace/memtrace.db` in place and tells you so; `varve store move`
relocates it to `.varve/varve.db` when you ask it to.

## Cutover

Done on 2026-07-30, with the v2.0.0 release. `scripts/cutover.sh` removed
`Formula/memtrace.rb` and added `formula_renames.json`; it is a one-time
script, kept for the record and because it refuses to run twice.

The ordering it guards is the part that was easy to get wrong: a rename map
without its target makes `brew install varve-sh/tap/memtrace` resolve to a
formula that is not there. So the script refuses to run until
`Formula/varve.rb` exists, which GoReleaser writes on the first **stable**
release — prereleases publish no formula (`skip_upload: auto`).
