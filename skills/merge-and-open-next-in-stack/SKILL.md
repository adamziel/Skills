---
name: merge-and-open-next-in-stack
description: Merge the current pull request in a stack after CI passes, using admin override only when appropriate, then determine where the stack should go next and find, create, or carve out the next small PR from the larger work branch. Use when the user asks to merge a stack PR and open or identify the next PR they should work with.
---

# Merge and Open Next in Stack

Use this skill when the current PR should already be prepared for review and the task is
to land it, then hand the user the next PR in the stack. If the PR still needs code
cleanup, description work, Copilot fixes, or CI repair, run `/prepare-for-merging` first
if available instead of turning this skill into a broad cleanup workflow.

## Operating principles

- Treat the PR number, branch, base, and stack position as facts to verify, not guesses.
- Keep this workflow narrow: wait for CI, merge, then find or create the next PR.
- Preserve stack order. Merge parents before children; retarget or rebase children after
  a parent merges.
- Use admin override only when the user explicitly authorized it or the current request
  says to, and only for policy/stale-state blockers after substantive requirements are
  satisfied. Never override real failing tests, unresolved required reviews, or known
  unaddressed review feedback.
- Never use bare `git push`; always specify remote and branch.

## Workflow

1. Identify the target PR.
   - If the user gives a number like `3927`, treat it as a GitHub PR number in the
     current repository.
   - Otherwise infer the PR for the current branch.
   - Fetch PR metadata: title, head branch, base branch, draft state, review decision,
     checks, mergeability, stack links, and related branch names.
   - Inspect local git status before changing files. Do not overwrite unrelated local
     changes.
2. Wait for CI and verify merge readiness.
   - Wait for required checks to finish.
   - If CI fails for a substantive reason, stop and report that `/prepare-for-merging`
     should fix it. Do not start broad debugging in this skill.
   - If a check is clearly flaky or stale, rerun or refresh it once when the repository
     workflow supports that.
   - Confirm the PR is non-draft and mergeable under the repository's normal policy.
3. Merge the current PR.
   - Use the repository's normal merge method.
   - If branch protection or GitHub state blocks the merge despite green CI and satisfied
     substantive requirements, use admin override only when authorized and explain why.
   - Do not delete the merged head branch until after child PRs are found/retargeted, and
     only delete it if that is safe for the stack.
4. Determine where the stack goes next.
   - Read the merged PR body, comments, linked issues, branch names, local branches,
     remote branches, and open PRs by the same author to infer the larger direction of
     the stack.
   - Look for an existing child PR whose base was the merged branch or whose commits build
     on it. If found, retarget/rebase/update it onto the correct new base, push with an
     explicit remote/branch, and report it as the next PR.
   - If no child PR exists, look for the larger work branch that still contains future
     stack work. Compare it with the new base and carve out the next coherent, small,
     reviewable slice into a fresh branch.
   - When carving, keep only the next slice: cherry-pick commits, split commits, or apply
     selected hunks as needed. Do not dump the rest of the large branch into the PR.
   - Open the next PR with clear stack context, base it on the correct branch, and make it
     the PR the user should work with next.
   - If there is no existing child PR and no remaining larger-branch work to carve out,
     report that the stack is complete.

## Handoff output

End with a concise status:

- merged PR: number/URL and merge method, including whether admin override was used
- CI: final state before merge
- stack direction: what larger branch/plan you inferred, or why none remains
- next PR: existing PR URL, newly created PR URL, or `stack complete`
- any required follow-up before the user starts working on the next PR
