---
description: Prepare a PR for review/merge: update description, document and clean up code, address Copilot feedback, mark ready, and get CI green.
argument-hint: "[PR number or URL]"
---

Invoke the `prepare-for-merging` skill on the target inferred from `$ARGUMENTS`.

- If `$ARGUMENTS` contains a PR number or URL, use that PR.
- If no target is provided, infer the PR for the current branch.
- If neither applies, ask which PR to prepare before doing anything else.

Follow the full skill workflow and do not finish prematurely: update the PR
description, improve documentation, simplify/rename suspect code, address Copilot
feedback, mark ready for review, and iterate until CI is green or a concrete
external blocker remains.
