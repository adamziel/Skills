---
description: Advance a stacked PR: address review, wait/fix CI, merge when safe, then identify or create the next PR.
argument-hint: "<PR number or URL> [goal/context]"
---

Invoke the `merge-and-open-next-in-stack` skill on the target inferred from `$ARGUMENTS`.

- If `$ARGUMENTS` contains a PR number or URL, use that PR.
- If no target is provided, infer the PR for the current branch.
- If neither applies, ask which PR to advance before doing anything else.

Follow the skill's workflow: resolve actionable review feedback, make CI green,
merge safely, then report the next PR in the stack, create one from remaining work,
or say the stack is complete.
