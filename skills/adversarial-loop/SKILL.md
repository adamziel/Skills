---
name: adversarial-loop
description: Iterate on a task by alternating an implementer Claude call and an independent verifier Claude call, looping up to 30 times until the verifier says PASS. Use when the user wants self-checking implementation.
---

# Adversarial loop

The user invokes this as `/adversarial-loop <task description>`. The arguments after the slash command are the task to implement. If the user provided no arguments, ask them what task to run before doing anything else.

## What to do

Set up a bash loop that alternates two non-interactive `claude -p` calls per iteration:

1. **Implementer** — gets the task plus all prior verifier feedback, then makes code changes in the repo.
2. **Verifier** — gets a *fresh* context with just the task and the implementer's short summary, then independently inspects the working tree and decides PASS or FAIL.

The loop stops on the first `VERDICT: PASS` line from the verifier, or after 30 iterations.

## Steps

1. Pick a working directory: `.adversarial-loop/$(date +%Y%m%d-%H%M%S)/`. Create it.
2. Write the user's task verbatim to `<workdir>/task.md`.
3. Write the bash script below to `<workdir>/run.sh` and `chmod +x` it.
4. Run the script via the Bash tool. For long tasks, run it in the background and tail `<workdir>/log.md` so the user sees progress.
5. When the loop ends, report: number of iterations, final verdict, and the path to the working directory so the user can inspect every iteration's intermediate files.

## Bash script template

Write this verbatim to `<workdir>/run.sh`:

```bash
#!/usr/bin/env bash
set -uo pipefail

WORK_DIR="$(cd "$(dirname "$0")" && pwd)"
TASK_FILE="$WORK_DIR/task.md"
FEEDBACK_FILE="$WORK_DIR/feedback.md"
LOG_FILE="$WORK_DIR/log.md"
MAX_ITER=30

: > "$FEEDBACK_FILE"
: > "$LOG_FILE"

for i in $(seq 1 "$MAX_ITER"); do
  echo "=== Iteration $i ===" | tee -a "$LOG_FILE"

  IMPL_PROMPT="$WORK_DIR/iter-$i-impl-prompt.md"
  IMPL_OUT="$WORK_DIR/iter-$i-impl-output.md"
  VERIFY_PROMPT="$WORK_DIR/iter-$i-verify-prompt.md"
  VERIFY_OUT="$WORK_DIR/iter-$i-verify-output.md"

  {
    echo "# Task"
    cat "$TASK_FILE"
    echo
    echo "# Prior verifier feedback"
    if [ -s "$FEEDBACK_FILE" ]; then
      cat "$FEEDBACK_FILE"
    else
      echo "(none — first iteration)"
    fi
    echo
    echo "# Instructions"
    echo "Implement the task above in the current repo. Make real edits."
    echo "If there is prior feedback, address every issue listed."
    echo "When done, print a short bullet-list summary of what you changed."
  } > "$IMPL_PROMPT"

  claude -p --dangerously-skip-permissions < "$IMPL_PROMPT" > "$IMPL_OUT" 2>&1 || {
    echo "Implementer call failed on iteration $i" | tee -a "$LOG_FILE"
    exit 2
  }

  {
    echo "# Task"
    cat "$TASK_FILE"
    echo
    echo "# Implementer summary"
    cat "$IMPL_OUT"
    echo
    echo "# Instructions"
    echo "Independently verify whether the task is correctly implemented in the current working directory. Inspect the actual files; do not trust the summary. Run quick checks (build, tests, type-check, grep) as needed."
    echo
    echo "End your response with EXACTLY one of these as the final line:"
    echo "VERDICT: PASS"
    echo "VERDICT: FAIL"
    echo
    echo "If FAIL, include a '## Issues' section above the verdict line with concrete, actionable problems for the next implementer iteration to fix."
  } > "$VERIFY_PROMPT"

  claude -p --dangerously-skip-permissions < "$VERIFY_PROMPT" > "$VERIFY_OUT" 2>&1 || {
    echo "Verifier call failed on iteration $i" | tee -a "$LOG_FILE"
    exit 3
  }

  if tail -n 10 "$VERIFY_OUT" | grep -qx "VERDICT: PASS"; then
    echo "PASS on iteration $i" | tee -a "$LOG_FILE"
    echo "$i" > "$WORK_DIR/passed-on-iteration.txt"
    exit 0
  fi

  echo "FAIL on iteration $i — feeding verifier output back to next implementer" | tee -a "$LOG_FILE"
  {
    echo
    echo "## Iteration $i verifier feedback"
    cat "$VERIFY_OUT"
  } >> "$FEEDBACK_FILE"
done

echo "Did not converge after $MAX_ITER iterations" | tee -a "$LOG_FILE"
exit 1
```

## Notes

- Each iteration writes four intermediate markdown files (`iter-N-impl-prompt.md`, `iter-N-impl-output.md`, `iter-N-verify-prompt.md`, `iter-N-verify-output.md`) so the user can audit the full back-and-forth after the run.
- The verifier is intentionally not given the implementer's prompt or prior feedback — only the original task and the implementer's own summary — so its judgment isn't anchored to the implementer's framing.
- `--dangerously-skip-permissions` is required because the sub-Claudes are running headless and cannot answer permission prompts. The user is opting into this when they invoke the skill.
- Do not silently lower `MAX_ITER` below 30. If the loop is too slow, surface that to the user and let them decide.
