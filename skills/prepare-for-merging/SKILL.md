---
name: prepare-for-merging
description: Prepare a GitHub pull request for review and eventual merge. Use when the user asks to get a PR ready, update the PR description, improve code documentation, clean up suspicious or fuzzy implementation, address Copilot feedback, mark a draft PR ready for review, wait for CI, fix CI failures, or keep iterating until the PR is green and ready for human review.
---

# Prepare for Merging

Use this skill when the user wants a PR made genuinely review-ready, not just a
quick pass. Expect the work to take time. Do not stop early while review issues,
quality concerns, or CI failures remain.

## Workflow

1. Identify the PR.
   - If the user gives a PR number or URL, use it.
   - Otherwise infer the PR for the current branch.
   - Inspect local git status first. Do not overwrite unrelated local changes.
2. Update the PR description.
   - Run `/update-pr-description` if that command/skill is available.
   - If it is not available, update the PR title/body directly with the same intent:
     specific behavior-focused wording, clear rationale, implementation notes, and
     testing instructions.
3. Improve code documentation.
   - Run `/documenting-code` if that command/skill is available.
   - Do not treat `/documenting-code` as sufficient by itself. Inspect the PR diff
     against its base and verify documentation coverage manually.
   - Ensure every named function, method, and named function-valued constant introduced
     or materially changed by the PR has a docblock, even when the behavior seems
     obvious from the name.
   - Include private helpers, React components, component-local handlers, and test
     helpers. Anonymous callbacks and one-off JSX handlers only need inline comments
     when they encode non-obvious intent or edge cases.
   - Add inline comments for longer or more complex stretches of code unless the intent
     is genuinely obvious.
   - Preserve existing intent, lifecycle, compatibility, edge-case, benchmark, and
     historical comments. Update them only when behavior changed.
4. Simplify obvious tiny helpers.
   - Inline methods and functions that are only 1-2 lines long and have only 1-2 callers,
     unless the helper carries important domain meaning, API boundary semantics, test
     seams, overload/type value, or future lifecycle clarity.
   - After inlining, remove only imports/variables/functions made unused by the change.
5. Replace opaque abbreviations.
   - Rename overly abbreviated identifiers to words that express meaning.
   - Prefer product/domain meaning over mechanical expansion. For example, use
     `current_base64` instead of `cb64` when that is the actual meaning.
   - Keep established external API names and third-party protocol names unchanged unless
     the PR intentionally changes that API.
6. Review rigorously and fix issues.
   - Inspect the PR diff against its base, not just the last commit.
   - Look for suspicious code, fuzzy logic, non-rigorous implementation, bad assumptions,
     inconsistencies with the rest of the codebase, and places that buffer slowly or
     wastefully when streaming is more appropriate.
   - Address real problems with the smallest coherent changes. Do not add speculative
     abstractions or unrelated cleanup.
7. Address Copilot/reviewer feedback.
   - Run `/copilot-review` if that command/skill is available.
   - Otherwise read unresolved Copilot and review comments directly, apply actionable
     fixes that belong to this PR, and reply or resolve only when fully addressed.
8. Mark ready for review.
   - If the PR is a draft and the substantive preparation above is complete, mark it
     ready for review.
9. Make CI green.
   - Wait for checks to complete.
   - If CI fails, inspect logs, reproduce locally when practical, fix the cause, run the
     relevant local checks, push the update, and wait again.
   - Iterate until required CI is green or there is a real external blocker.

## Pushing and status

- Commit coherent changes when needed.
- Push with an explicit remote and branch; never use bare `git push`.
- Do not finish with vague “looks good” language. End only when the PR is ready for the
  user's review, CI is green, or a concrete blocker remains.

Final response must include:

- PR URL/number
- description update status
- documentation and cleanup summary
- Copilot/reviewer feedback status
- CI final state
- whether the PR is ready for review
- any remaining blocker or risk
