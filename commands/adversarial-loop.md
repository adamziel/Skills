---
description: Compatibility alias for /autonomous-loop. Creates a durable autonomous build loop instead of the old bounded implementer/verifier loop.
argument-hint: "<goal>"
---

Invoke the `autonomous-loop` skill with the goal: $ARGUMENTS

If `$ARGUMENTS` is empty, ask the user what goal the loop should pursue before doing anything else. Otherwise follow the `autonomous-loop` skill. If the user explicitly asks for adversarial verification, add verifier tasks as part of the autonomous loop state rather than replacing the durable loop.
