---
name: merge-and-open-next-in-stack
description: Advance and manage a stack of small pull requests cut from a larger body of work. Use when the user asks to handle a PR in a stack, address Copilot or reviewer feedback, wait for CI, fix failures, merge with an admin override if appropriate, retarget/rebase child PRs, identify the next PR in the stack, create the next PR from remaining commits, or report that the stack is done.
---

# Merge and Open Next in Stack

Use this skill to turn prompts like `3927: address copilot review, wait for CI to pass,
fix any failures, merge, then give the next PR in this stack` into a safe, repeatable
stack-advancement workflow.

## Operating principles

- Treat the PR number, branch, base, and stack position as facts to verify, not guesses.
- Keep each PR small and independently reviewable. Do not mix unrelated cleanup into the
  current PR just because it is nearby.
- Finish the current PR before advancing the stack unless the current PR is blocked.
- Preserve stack order. Merge parents before children; retarget or rebase children after
  a parent merges.
- Prefer ordinary merges. Use admin override only when the user explicitly authorized it
  or the current request says to, and only for policy/stale-state blockers, never to
  bypass real failing tests, unresolved required reviews, or unaddressed review feedback.
- Never use bare `git push`; always specify remote and branch.

## Workflow

1. Identify the target.
   - If the user gives a number like `3927`, treat it as a GitHub PR number in the
     current repository.
   - Fetch PR metadata: title, head branch, base branch, draft state, review decision,
     checks, mergeability, and linked/stacked PR references.
   - Inspect local git state before changing files. If unrelated local changes exist,
     do not overwrite them.
2. Resolve review feedback.
   - Read unresolved review threads, especially Copilot comments and requested changes.
   - Apply only actionable fixes that belong to the current PR.
   - Push fixes to the PR head branch with an explicit remote and branch.
   - Reply to or resolve threads only when the code change or explanation fully answers
     them.
3. Make CI green.
   - Wait for required checks to finish.
   - If checks fail, inspect logs, reproduce locally when practical, apply the smallest
     fix, run the relevant local test/check, push, and wait again.
   - Treat infra flakes conservatively: rerun once if clearly flaky; otherwise diagnose.
4. Merge the current PR.
   - Confirm the PR is non-draft, approved or reviewable under the repo policy, up to
     date enough for the repository's merge rules, and CI is green.
   - Use the repository's normal merge method. If branch protection reports a stale or
     administrative-only blocker despite satisfied substantive requirements, and the
     user authorized override, use the override and say exactly why.
   - Delete the merged head branch only if that is the repository's normal practice and
     there are no child PRs depending on it.
5. Advance the stack.
   - Find child PRs by checking PR body links, branch naming, PRs whose base was the
     merged branch, local branch ancestry, and open PRs by the same author.
   - If an open child PR exists, retarget/rebase/update it onto the correct new base
     (usually the merged PR's base branch), push with explicit remote/branch, and report
     that PR as next.
   - If no child PR exists but local commits remain for the larger body of work, create
     the next small branch and PR from the next coherent slice only. Include a clear PR
     title/body, tests, and stack context.
   - If no child PR and no remaining work exists, report that the stack is done.

## Handoff output

End with a concise status:

- current PR: merged / blocked / still open, with reason
- reviews: addressed or remaining threads
- CI: final state and fixes made
- merge: method used, including whether admin override was used
- next PR: number + URL, newly created PR URL, or `stack complete`
- anything the next agent should know before continuing
