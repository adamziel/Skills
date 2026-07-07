---
description: Update a GitHub PR title and description with clear, specific wording.
argument-hint: "[PR URL/number and optional context or focus area]"
---

Invoke the `writing-pr-descriptions` skill.

- Update GitHub directly unless the user explicitly asks for draft text only.
- Compare the branch against the PR base branch, not just the last commit.
- Make the title name the primary behavior change without overstating the outcome.
- Make the first description sentence say what changes for the user and why the PR exists.
- For failure paths, describe the trigger, stored state, next code path, and direct failure outcome.
- Avoid vague phrasing such as “restore more predictably,” “improves handling,” or “fixes edge cases.”
