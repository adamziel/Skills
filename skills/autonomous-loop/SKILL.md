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
6. Smoke-test the script:
   - `bash -n run_autonomous_loop.sh`
   - a short bounded invocation such as `timeout 10s ./run_autonomous_loop.sh` when it is safe to start one agent call, or a direct non-mutating CLI check if credentials/cost make that risky.
7. Give the user the exact command to run. Do not start the infinite loop unless the user explicitly asked you to run it.

## Runner Requirements

The generated runner must:

- run forever until interrupted by the user, with no sleep between successful sessions
- immediately start the next agent session after a successful one
- fail fast on CLI/script errors and print the relevant log tail instead of spinning
- preflight the chosen agent CLI before entering the loop
- support Codex by default when available, and Claude as a fallback
- pass memory/progress/goal file paths into every session
- ask the agent to update memory and progress before finishing
- ask the agent to run relevant tests and commit coherent changes
- auto-commit leftover changes after a successful session if the agent did not
- keep logs quiet under the state directory
- avoid committing secrets, logs, or tmp files

## Prompt Shape

Every loop iteration should tell the agent:

- it is one worker in an unattended loop
- where to find the goal, memory, progress, and logs
- to inspect the repo before changing files
- to choose the highest-priority unfinished work
- to make production-quality changes, not a demo-only slice
- to fill in missing user flows implied by the goal
- to add/update tests and run relevant checks
- to update memory/progress before the final response
- to keep the final response short: changes, tests, risks/blockers, next step
- not to block on secrets or external accounts; build configuration/error paths instead

## Verifier Option

If the user explicitly wants adversarial verification, keep it as a phase inside the autonomous loop rather than as the whole architecture:

- Add a `verify` section to `progress.md`.
- Instruct normal worker sessions to leave concrete verification tasks.
- Optionally create a second finite verifier script that reads the same state files and writes findings into `memory.md` or `progress.md`.

The main durable loop remains the source of continuity.

## Output To User

Report:

- script path
- state directory path
- Git commit created
- tests/smoke checks run
- command to start the loop

Keep the answer concise.
