---
description: Wait for CI, merge a stack PR when safe, then find, create, or carve out the next PR in the stack.
argument-hint: "<PR number or URL> [stack context]"
---

Invoke the `merge-and-open-next-in-stack` skill on the target inferred from `$ARGUMENTS`.

- If `$ARGUMENTS` contains a PR number or URL, use that PR.
- If no target is provided, infer the PR for the current branch.
- If neither applies, ask which PR to merge before doing anything else.

Follow the skill's narrow workflow: wait for CI, merge safely with admin override
only when appropriate, then infer the stack direction and find, create, or carve
out the next small PR the user should work with.
