---
name: adversarial-loop
description: Compatibility alias for autonomous-loop. Use when the user asks for the old adversarial-loop workflow; create a durable autonomous build loop with persistent memory, progress, quiet logs, Git commits, tests, and optional verifier tasks instead of the old bounded implementer/verifier loop.
---

# Adversarial loop compatibility

This skill name is kept for old prompts and installs. Prefer `autonomous-loop`.

When invoked, follow `../autonomous-loop/SKILL.md` if that file is available. If it is not available, do not recreate the old finite implementer/verifier script. Create a durable repo-local autonomous loop instead:

- store the goal, memory, progress, logs, and runtime files in a repo-local state directory
- run fresh Codex or Claude sessions repeatedly until interrupted
- hide intermediate session output in logs while showing high-level progress in the terminal
- fail fast on CLI/script errors and print the relevant log tail
- ask every session to test, commit coherent changes, and update memory/progress
- keep adversarial verification as an optional phase inside the durable loop state
