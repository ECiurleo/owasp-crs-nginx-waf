#!/usr/bin/env bash
set -euo pipefail

BASE_URL="http://localhost"
SKIP_COMPOSE_UP=0

usage() {
  cat <<'EOF'
Usage: ./tests/security/run-owasp-crs-smoke.sh [options]

Options:
  -b, --base-url URL       Base URL for tests (default: http://localhost)
  -s, --skip-compose-up    Do not run docker compose up -d --build
  -h, --help               Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -b|--base-url)
      BASE_URL="$2"
      shift 2
      ;;
    -s|--skip-compose-up)
      SKIP_COMPOSE_UP=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      exit 2
      ;;
  esac
done

assert_status() {
  local name="$1"
  local actual="$2"
  shift 2
  local expected=("$@")

  for e in "${expected[@]}"; do
    if [[ "$actual" == "$e" ]]; then
      echo "[PASS] $name - status $actual"
      return 0
    fi
  done

  echo "[FAIL] $name - expected ${expected[*]} but got $actual"
  return 1
}

request_status() {
  local url="$1"
  local ua="${2:-}"
  local code

  if [[ -n "$ua" ]]; then
    code=$(curl -sS -o /dev/null -w "%{http_code}" -A "$ua" --max-time 20 "$url")
  else
    code=$(curl -sS -o /dev/null -w "%{http_code}" --max-time 20 "$url")
  fi

  echo "$code"
}

if [[ "$SKIP_COMPOSE_UP" -eq 0 ]]; then
  echo "Starting compose stack..."
  docker compose up -d --build >/dev/null
fi

ok=0

status=$(request_status "$BASE_URL/")
assert_status "Benign request" "$status" 200 404 || ok=1

status=$(request_status "$BASE_URL/?id=1%20OR%201=1")
assert_status "SQLi probe" "$status" 403 406 || ok=1

status=$(request_status "$BASE_URL/?q=%3Cscript%3Ealert(1)%3C%2Fscript%3E")
assert_status "XSS probe" "$status" 403 406 || ok=1

status=$(request_status "$BASE_URL/?file=..%2F..%2F..%2Fetc%2Fpasswd")
assert_status "LFI probe" "$status" 403 406 || ok=1

status=$(request_status "$BASE_URL/?cmd=%3Bcat%20%2Fetc%2Fpasswd")
assert_status "RCE probe" "$status" 403 406 || ok=1

status=$(request_status "$BASE_URL/" "sqlmap/1.9")
assert_status "Scanner header probe" "$status" 403 406 || ok=1

waf_container=$(docker compose ps -q waf)
if [[ -n "$waf_container" ]]; then
  echo
  echo "Inspecting WAF rule engine inside container..."
  docker exec "$waf_container" sh -lc "grep -n '^SecRuleEngine' /etc/nginx/modsecurity.conf"
fi

if [[ "$ok" -ne 0 ]]; then
  echo "One or more OWASP CRS checks failed." >&2
  exit 1
fi

echo "All OWASP CRS checks passed."