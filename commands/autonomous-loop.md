---
description: Create a durable autonomous loop that repeatedly reprompts Codex or Claude with persistent memory, progress, quiet logs, Git commits, tests, and fail-fast observability.
argument-hint: "<goal>"
---

Invoke the `autonomous-loop` skill with the goal: $ARGUMENTS

If `$ARGUMENTS` is empty, ask the user what goal the loop should pursue before doing anything else. Otherwise follow the skill's steps: create the state directory, write the goal/memory/progress files, copy and customize the loop runner, smoke-test it, commit the bootstrap, and print the exact command the user should run. Do not start the infinite loop yourself unless the user explicitly asks you to run it.

Make sure the generated loop instructions include these operating nuances:

- Commit coherent progress often, so older variants are recoverable.
- Create local-only annotated `known-good/...` tags for major verified stable states, but not for every commit or ordinary checkpoint.
- Keep progress visible: every loop restart/iteration must print the current progress summary before launching the next agent session.
