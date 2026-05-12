#!/usr/bin/env bash
set -euo pipefail

RUNNER="${1:-}"
if [[ -z "$RUNNER" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  RUNNER="$SCRIPT_DIR/../assets/run_autonomous_loop.sh"
fi

if [[ ! -f "$RUNNER" ]]; then
  echo "Runner not found: $RUNNER" >&2
  exit 2
fi

bash -n "$RUNNER"

if grep -nE '(^|[;&|[:space:]])sleep([[:space:]]|$)' "$RUNNER"; then
  echo "Runner contains a pause command; autonomous loops must not pause between sessions." >&2
  exit 3
fi

tmpdir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

repo="$tmpdir/repo"
bin_dir="$tmpdir/bin"
mkdir -p "$repo/.autonomous-loop/logs" "$repo/.autonomous-loop/tmp" "$bin_dir"
cp "$RUNNER" "$repo/run_autonomous_loop.sh"
chmod +x "$repo/run_autonomous_loop.sh"

cat > "$repo/.gitignore" <<'IGNORE'
.autonomous-loop/logs/
.autonomous-loop/tmp/
IGNORE

cat > "$repo/.autonomous-loop/goal.md" <<'GOAL'
# Goal

Exercise the autonomous loop runner with a fake agent.
GOAL

cat > "$repo/.autonomous-loop/memory.md" <<'MEMORY'
# Memory

- Smoke test fixture.
MEMORY

cat > "$repo/.autonomous-loop/progress.md" <<'PROGRESS'
# Progress

## Current Checklist

- [ ] Prove the loop starts.
- [ ] Prove the loop fails fast.

## Next Best Step

- Run the fake agent.
PROGRESS

cat > "$bin_dir/codex" <<'FAKECODEX'
#!/usr/bin/env bash
if printf '%s\n' "$@" | grep -qx -- '--help'; then
  echo 'fake codex help'
  exit 0
fi

last_message=''
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --output-last-message)
      last_message="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

count_file="${FAKE_COUNT_FILE:?}"
count=0
if [[ -f "$count_file" ]]; then
  count="$(cat "$count_file")"
fi
count=$((count + 1))
printf '%s\n' "$count" > "$count_file"

echo "fake codex iteration $count"
if [[ -n "$last_message" ]]; then
  printf 'fake last message %s\n' "$count" > "$last_message"
fi

if [[ "$count" -ge 2 ]]; then
  echo 'intentional fake failure'
  exit 42
fi

exit 0
FAKECODEX
chmod +x "$bin_dir/codex"

set +e
FAKE_COUNT_FILE="$tmpdir/count" \
PATH="$bin_dir:$PATH" \
LOOP_AGENT=codex \
AGENT_BIN=codex \
"$repo/run_autonomous_loop.sh" > "$tmpdir/run.out" 2>&1
status=$?
set -e

if [[ "$status" -ne 42 ]]; then
  echo "Expected runner to exit with fake agent status 42, got $status" >&2
  sed -n '1,220p' "$tmpdir/run.out" >&2
  exit 4
fi

required_patterns=(
  'Autonomous Build Loop'
  'Agent: codex (codex)'
  'Iteration: 1'
  'Iteration: 2'
  'Current session log:'
  'Progress'
  'Last Agent Result'
  'Status'
  'fake last message 1'
  'Agent exited with status 42'
  'Last log lines:'
  'intentional fake failure'
)

for pattern in "${required_patterns[@]}"; do
  if ! grep -Fq "$pattern" "$tmpdir/run.out"; then
    echo "Missing expected output pattern: $pattern" >&2
    sed -n '1,260p' "$tmpdir/run.out" >&2
    exit 5
  fi
done

count="$(cat "$tmpdir/count")"
if [[ "$count" != "2" ]]; then
  echo "Expected exactly 2 fake agent invocations, got $count" >&2
  sed -n '1,260p' "$tmpdir/run.out" >&2
  exit 6
fi

log_count="$(find "$repo/.autonomous-loop/logs" -type f -name 'iteration-*.log' | wc -l | tr -d ' ')"
if [[ "$log_count" != "2" ]]; then
  echo "Expected exactly 2 iteration logs, got $log_count" >&2
  find "$repo/.autonomous-loop/logs" -type f -maxdepth 1 -print >&2
  exit 7
fi

echo "smoke test passed: runner starts, advances without sleep, reports progress, and fails fast"
