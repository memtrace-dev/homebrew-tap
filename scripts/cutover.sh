#!/usr/bin/env bash
# Completes the memtrace -> varve rename in this tap.
#
# Run this ONCE, after the first stable varve release has published
# Formula/varve.rb. It is guarded, because the ordering is the part that is easy
# to get wrong: adding formula_renames.json before varve.rb exists makes
# `brew install varve-sh/tap/memtrace` resolve to a formula that is not there,
# which breaks the only thing this tap currently does.
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ ! -f Formula/varve.rb ]]; then
  cat >&2 <<'MSG'
refusing: Formula/varve.rb does not exist yet.

GoReleaser writes it during the first STABLE release of varve-sh/varve
(prereleases are skipped — see skip_upload: auto in .goreleaser.yaml).
Until then `memtrace` is the only formula this tap serves, and removing it
would leave the tap with nothing.

Tag a stable release first, let the Release workflow finish, `git pull`, then
run this again.
MSG
  exit 1
fi

if [[ -f formula_renames.json ]]; then
  echo "already cut over: formula_renames.json exists" >&2
  exit 0
fi

git rm -q Formula/memtrace.rb
cat > formula_renames.json <<'JSON'
{
  "memtrace": "varve"
}
JSON
git add formula_renames.json

git commit -q -m "chore: complete the memtrace -> varve rename

Formula/varve.rb now exists, so the rename map can land. Homebrew reads
formula_renames.json and migrates memtrace users to varve on \`brew upgrade\`,
which is why memtrace.rb is removed in the same commit rather than left as a
second formula for the same project.

Deliberately not done earlier: the map without the target formula makes
\`brew install varve-sh/tap/memtrace\` resolve to something that does not exist."

echo "cutover committed. Verify, then: git push origin main"
echo
echo "A user on memtrace now gets varve from:  brew upgrade"
