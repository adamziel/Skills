---
name: autonomous-loop
description: Create a durable repo-local bash loop that repeatedly reprompts Codex or Claude to advance a product or codebase, with persistent memory, progress checklists, quiet logs, Git commits, tests, and fail-fast observability. Use when the user wants an unattended build loop, self-propelling implementation loop, or a replacement for an adversarial implementer/verifier loop.
---

# Autonomous loop

The user invokes this as `/autonomous-loop <goal>`. `/adversarial-loop` may be kept as a compatibility alias, but the preferred name is `autonomous-loop` because the workflow is an orchestrated build loop, not only a verifier duel.

If the user gave no goal, ask for the goal before doing anything else.

## Philosophy

Create an observable loop runner first. The runner should keep enough durable state that each fresh agent session can continue the work without chat history, while the terminal shows only the big picture:

- product or task brief
- persistent memory
- progress checklist
- last agent result
- current Git status
- current quiet log path

Do not stream intermediate agent artifacts to the terminal. Write them to logs and state files.

This skill exists because a naive loop script is easy to make and easy to break. Do not stop at "it looks right". Prove the generated runner starts correctly, invokes the selected agent with the installed CLI syntax, and fails loudly instead of spinning if the agent invocation is wrong.

## Default Workflow

1. Pick the target repo root. Usually it is the current working directory.
2. Create a repo-local state directory, default `.autonomous-loop/`, with:
   - `goal.md` containing the user's goal verbatim, plus any clarified requirements.
   - `memory.md` for durable architecture decisions, constraints, and handoff notes.
   - `progress.md` with checkboxes and a "Next Best Step" section.
   - `logs/` and `tmp/` for quiet runtime artifacts.
3. Copy `assets/run_autonomous_loop.sh` from this skill to a repo script such as `run_autonomous_loop.sh`, `chmod +x` it, then customize names and prompt details only where the user's task needs it.
4. Add log/runtime ignores to the repo's ignore file:
   - `.autonomous-loop/logs/`
   - `.autonomous-loop/tmp/`
5. Initialize Git if needed. Commit the loop script and state bootstrap.
   - Tell worker sessions to commit coherent changes often, at natural milestones, so older variants remain recoverable.
   - Tell worker sessions to create annotated `known-good/...` tags only for major verified stable states, not for routine checkpoints.
   - Known-good tags must stay local by default. Do not push tags unless the user explicitly asks.
6. Smoke-test the script:
   - `bash -n run_autonomous_loop.sh`
   - `skills/autonomous-loop/scripts/smoke_test_runner.sh ./run_autonomous_loop.sh` from this skill repo, or copy/run that script against the generated runner.
   - If also using the real agent CLI, run a tiny non-mutating direct invocation before trusting the infinite loop. For Codex, verify that approval options are placed before `exec` for CLIs that require that shape.
7. Give the user the exact command to run. Do not start the infinite loop unless the user explicitly asked you to run it.

## Runner Requirements

The generated runner must:

- run forever until interrupted by the user, with no sleep between successful sessions
- immediately start the next agent session after a successful one
- fail fast on CLI/script errors and print the relevant log tail instead of spinning or retrying
- preflight the chosen agent CLI before entering the loop
- support Codex by default when available, and Claude as a fallback
- pass memory/progress/goal file paths into every session
- ask the agent to update memory and progress before finishing
- ask the agent to run relevant tests and commit coherent changes
- auto-commit leftover changes after a successful session if the agent did not
- ask the agent to use local-only annotated `known-good/...` tags sparingly for major verified states
- keep logs quiet under the state directory
- avoid committing secrets, logs, or tmp files

No `sleep` belongs in the loop body, including a "courtesy" delay after each session. If a user asks for a no-sleep loop, inspect the generated script for `sleep` before reporting success.

## Terminal Contract

Every iteration must clear/redraw to a concise dashboard with these exact sections in this order:

1. Header:
   - loop name
   - start timestamp
   - agent name and binary
   - iteration number
   - Git branch, HEAD, and uncommitted path count
   - current session log path
2. `Progress`
   - print the top of `progress.md`
   - checkboxes must show the big picture, not low-level artifacts
   - this must happen every time the loop starts or restarts an iteration, before launching the next agent session
3. `Last Agent Result`
   - print only a short tail/head of the previous final response
   - print a clear empty state on the first iteration
4. `Status`
   - print one line saying the agent is starting and output is going only to the log file

On agent failure, print:

- exit status
- log file path
- `Last log lines`
- the last relevant log tail

Then exit with the same nonzero status. Do not continue to the next iteration after a failed agent call.

## Prompt Shape

Every loop iteration should tell the agent:

- it is one worker in an unattended loop
- where to find the goal, memory, progress, and logs
- to inspect the repo before changing files
- to choose the highest-priority unfinished work
- to make production-quality changes, not a demo-only slice
- to fill in missing user flows implied by the goal
- to add/update tests and run relevant checks
- to commit coherent progress often at natural milestones
- to create local-only annotated `known-good/...` tags only for major verified stable states, and not for every commit
- to update memory/progress before the final response
- to keep the final response short: changes, tests, risks/blockers, next step
- not to block on secrets or external accounts; build configuration/error paths instead

## Verifier Option

If the user explicitly wants adversarial verification, keep it as a phase inside the autonomous loop rather than as the whole architecture:

- Add a `verify` section to `progress.md`.
- Instruct normal worker sessions to leave concrete verification tasks.
- Optionally create a second finite verifier script that reads the same state files and writes findings into `memory.md` or `progress.md`.

The main durable loop remains the source of continuity.

## Required Smoke Test Semantics

The bundled smoke test uses a fake Codex binary, so it does not spend tokens or depend on credentials. It must demonstrate:

- the runner passes `bash -n`
- no `sleep` command is present
- preflight accepts the fake CLI
- iteration 1 succeeds
- iteration 2 starts immediately
- the previous result appears in `Last Agent Result`
- a forced iteration-2 agent failure exits nonzero
- the terminal output includes the dashboard sections listed above
- the failure output includes the log tail

If this smoke test fails, fix the runner before reporting back. Do not tell the user to ignore the error or manually skip the failing path.

## Output To User

Report:

- script path
- state directory path
- Git commit created
- tests/smoke checks run, including whether the fake-agent runner test passed
- command to start the loop

Keep the answer concise.
