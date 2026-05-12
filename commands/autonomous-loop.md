---
description: Create a durable autonomous loop that repeatedly reprompts Codex or Claude with persistent memory, progress, quiet logs, Git commits, tests, and fail-fast observability.
argument-hint: "<goal>"
---

Invoke the `autonomous-loop` skill with the goal: $ARGUMENTS

If `$ARGUMENTS` is empty, ask the user what goal the loop should pursue before doing anything else. Otherwise follow the skill's steps: create the state directory, write the goal/memory/progress files, copy and customize the loop runner, smoke-test it, commit the bootstrap, and give the user the command to run.
