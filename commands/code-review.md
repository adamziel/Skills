---
description: Review the pending changes on the current branch (or a specified PR) for correctness, security, tests, and clarity.
argument-hint: "[PR number or URL — optional]"
---

Invoke the `code-review` skill on the target inferred from `$ARGUMENTS`.

- If `$ARGUMENTS` contains a PR number or URL, review that PR.
- Otherwise, review the current branch's diff against the merge-base with the default branch.
- If neither applies (no diff, no argument), ask the user what to review before doing anything else.

Follow the skill's instructions exactly: severity-grouped findings (Blocker / Should fix / Nit / Question), each with `path:line`, ending in a one-paragraph summary.
