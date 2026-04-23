---
description: Iterate on a task by alternating an implementer Claude call and an independent verifier Claude call, looping up to 30 times until the verifier says PASS.
argument-hint: "<task description>"
---

Invoke the `adversarial-loop` skill with the task: $ARGUMENTS

If `$ARGUMENTS` is empty, ask the user what task to run before doing anything else. Otherwise follow the skill's steps verbatim — create the working directory, write `task.md` and `run.sh`, run the loop, and report the final verdict and working-directory path.
