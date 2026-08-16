#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"
fail=0

private_paths="$(find . -path './.git' -prune -o \
  \( -path './data/graph.json' -o -path './data/participants.json' \
     -o -path './data/parse-participants.mjs' -o -path './participants/*' \
     -o -path '*/.claude/*' -o -path '*/.codex/*' -o -path '*/.cursor/*' \
     -o -path '*/_sessions/*' -o -path '*/file-history/*' \
     -o -iname '*.jsonl' -o -iname '*.sqlite' -o -iname '*.sqlite3' \
     -o -iname '*.db' -o -iname '*.pem' -o -iname '*.key' \
     -o -name 'HANDOFF.md' -o -name 'CONTEXT-HANDOFF.md' \
     -o -name 'SESSION-*-HANDOFF.md' -o -name '*.backup-*' \) -print | sed 's#^./##')"
if [[ -n "$private_paths" ]]; then
  printf 'privacy check failed: private source/session artifact\n%s\n' "$private_paths" >&2
  fail=1
fi

content_pattern='(/Users/[A-Za-z0-9._-]+/|/home/[A-Za-z0-9._-]+/|"(sessionId|parentUuid|cwd|transcript_path)"[[:space:]]*:|MTProto session|TELEGRAM_API_(ID|HASH)|sk-or-v1-|sk-[A-Za-z0-9_-]{20,})'
if git grep -IEn "$content_pattern" -- . \
  ':(exclude)scripts/privacy-check.sh' \
  ':(exclude).github/workflows/privacy.yml'; then
  printf 'privacy check failed: private identity, runtime, or credential marker found\n' >&2
  fail=1
fi

if command -v gitleaks >/dev/null 2>&1; then
  gitleaks git --redact --no-banner --exit-code 1 . || fail=1
else
  printf 'privacy check failed: gitleaks is required\n' >&2
  fail=1
fi

exit "$fail"
