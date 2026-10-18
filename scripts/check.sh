#!/bin/sh
# Local validation for `api` (GOVERNANCE.md section 6.6).
#
# This repository commits no workflows: every check runs on the machine that made
# the change. Run from anywhere:
#
#   scripts/check.sh                       # every check
#   scripts/check.sh buf spectral          # only the named checks
#
# Exit code: 0 every check passed, 1 one or more failed, 2 usage error.
set -eu

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

# Versions the former workflow pinned; used through npx when the tool is absent.
buf_version="1.74.0"
spectral_version="6.17.0"

default_checks="buf breaking spectral json naming reuse gitleaks"
if [ "$#" -gt 0 ]; then
  checks="$*"
else
  checks="$default_checks"
fi

builder="${BUILDER:-$(cd "$root/.." && pwd)/builder}"

failures=""
skips=""

pass() { echo "==> $1: ok"; }
fail() { echo "==> $1: FAILED" >&2; failures="$failures $1"; }
skip() { echo "==> $1: skipped ($2)"; skips="$skips $1"; }

buf() {
  if command -v buf >/dev/null 2>&1; then
    command buf "$@"
  elif command -v npx >/dev/null 2>&1; then
    npx --yes "@bufbuild/buf@$buf_version" "$@"
  else
    return 127
  fi
}

for check in $checks; do
  case "$check" in
  buf)
    if ! command -v buf >/dev/null 2>&1 && ! command -v npx >/dev/null 2>&1; then
      skip buf "neither buf nor npx is installed"
    elif buf lint; then
      pass buf
    else
      fail buf
    fi
    ;;
  breaking)
    # The contracts are permanent: compare against `main`. Needs a git history.
    if ! git rev-parse --verify --quiet main >/dev/null 2>&1; then
      skip breaking "no main branch yet"
    elif buf breaking --against '.git#branch=main'; then
      pass breaking
    else
      fail breaking
    fi
    ;;
  spectral)
    if command -v spectral >/dev/null 2>&1; then
      if spectral lint openapi/v1/zarish-api.yaml; then pass spectral; else fail spectral; fi
    elif command -v npx >/dev/null 2>&1; then
      if npx --yes "@stoplight/spectral-cli@$spectral_version" lint \
        openapi/v1/zarish-api.yaml; then
        pass spectral
      else
        fail spectral
      fi
    else
      skip spectral "neither spectral nor npx is installed"
    fi
    ;;
  json)
    status=0
    for file in $(find json-schema mcp/tools -name '*.json' 2>/dev/null | sort); do
      if python3 -m json.tool "$file" >/dev/null 2>&1; then
        echo "    valid JSON: $file"
      else
        echo "    invalid JSON: $file" >&2
        status=1
      fi
    done
    if [ "$status" -eq 0 ]; then pass json; else fail json; fi
    ;;
  naming)
    lint="$builder/target/debug/zarish-naming-lint"
    if [ ! -x "$lint" ]; then
      skip naming "build it with: cargo build -p zarish-naming-lint (in builder)"
    elif "$lint" check --repo "$root" --name api \
      --config "$builder/policies/naming.toml"; then
      pass naming
    else
      fail naming
    fi
    ;;
  reuse)
    if ! command -v reuse >/dev/null 2>&1; then
      skip reuse "reuse is not installed"
    elif reuse lint; then
      pass reuse
    else
      fail reuse
    fi
    ;;
  gitleaks)
    if ! command -v gitleaks >/dev/null 2>&1; then
      skip gitleaks "gitleaks is not installed"
    elif gitleaks detect --no-git --redact --source .; then
      pass gitleaks
    else
      fail gitleaks
    fi
    ;;
  *)
    echo "unknown check: $check" >&2
    echo "known checks: $default_checks" >&2
    exit 2
    ;;
  esac
done

echo
if [ -n "$skips" ]; then
  echo "skipped:$skips"
fi
if [ -n "$failures" ]; then
  echo "failed:$failures" >&2
  exit 1
fi
echo "all checks passed"
