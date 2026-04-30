---
description: Document code in a useful, developer-friendly way.
argument-hint: "[file or symbol to document — optional]"
---

Invoke the `documenting-code` skill on the target inferred from `$ARGUMENTS`.

- If `$ARGUMENTS` names a file or symbol, document that specific code.
- Otherwise, document the code most relevant to the current task or recent changes.
- Follow the skill's guidelines: explain WHY not WHAT, use descriptive names, document constraints and edge cases, never document the obvious.
