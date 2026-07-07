---
name: writing-pr-descriptions
description: Update GitHub PR titles and descriptions with clear, specific, human-oriented wording. Prefer the `/update-pr-description` command; `/writing-pr-descriptions` remains a compatibility alias.
---

When writing or updating PR titles and descriptions, write the right things, not a lot of things. Be concise, specific, and concrete about the behavior change and the failure or motivation behind it.

When the user asks to update a GitHub PR title or description, update GitHub directly unless they explicitly ask for draft text only.

# Process

Before writing, compare the branch against the PR base branch, not just the last commit:

```bash
git diff <base>...HEAD
git log <base>...HEAD --oneline
```

Use `trunk` or `main` as appropriate for the repo. This shows the full scope of changes.

# Title and First Sentence

The PR title must name the primary behavior change, not a broad outcome. For failure-path PRs, prefer titles shaped like:

- `[Area] Stop <wrong behavior>`
- `[Area] Prevent <bad state>`
- `[Area] Show <specific error>`
- `[Area] Detect <specific condition>`

Avoid title words like “fix,” “improve,” “restore,” or “preserve” unless the PR literally does that as its main behavior. Do not force secondary changes into the title; cover them in the description.

The first sentence of the PR description must summarize what changes for the user and why the PR exists. It should be specific enough to match the code, but not so detailed that it becomes an implementation summary.

# Default Shape

Use these sections by default:

## What it does
## Rationale
## Testing instructions

Add `## Implementation` only when it helps reviewers understand one or two non-obvious design choices. If the implementation can be explained in one sentence inside `What it does` or `Rationale`, do not create a separate section.

# Section Guidance

## What it does

Say what behavior, API, invariant, or workflow changed. Mention important non-goals when they prevent reviewer confusion, especially in stacked PRs.

## Rationale

Explain why the change exists and why this PR is shaped this way. For stacked PRs, explain what this PR adds on top of the previous PR and what remains for later PRs.

For failure paths, use this shape:

`When [user action], [stored state] remains. Then [code path] does [wrong action]. It fails because [specific invariant/state].`

State the direct outcome before examples. Prefer:

> `bootSiteClient()` mounted the partial OPFS directory and tried to boot it. It would not boot because the initial sync never finished.

over:

> This is bad because files, config, plugins, or uploads may be missing.

Avoid vague causal phrases such as “we looked here because,” “could be found again,” “restore more predictably,” “improves handling,” and “fixes edge cases.” If a sentence cannot point to a specific state, file, flag, UI message, or code path, rewrite it.

## Implementation

Summarize the mechanism at the right level. Use a short numbered list when the flow matters. Include a tiny code example only when it clarifies a non-obvious design. Skip this section when the mechanism fits naturally in `What it does` or `Rationale`.

## Testing instructions

List concrete commands and manual checks. Prefer exact commands in a fenced code block. Add any caveats such as version-gated tests or skipped fixtures.

# Writing Guidelines

**PR titles:** Never start PR titles with `[codex]`, `Codex:`, or any AI/tool label. Never add Codex/OpenAI co-author trailers or AI disclosure boilerplate to PR descriptions.

**Be specific.** Use inline `code` for technical terms: `TokenRefresher`, `SESSION_TIMEOUT`, `/api/v2/auth`.

**Be concise.** Every sentence should add new information. Cut the fluff.

**Use formatting.** `code`, **bold**, _emphasis_, and code blocks make descriptions scannable.

**Show, don't tell.** Code examples beat vague descriptions.

**Avoid file-by-file changelogs.** The diff already shows files. Explain the product or technical change instead.

**Keep language clear without dumbing it down.** Write for a junior developer whose second language is English, but do not over-explain basic project concepts.

# Examples

## Good: Failure Path

```markdown
## What it does

Stops browser-stored Playgrounds from booting OPFS WordPress files when the first save did not finish, and shows an interrupted-save message instead.

## Rationale

A user can open a Playground URL that starts an autosaved browser-stored site, then close or reload the tab before the first MEMFS-to-OPFS copy finishes. At that point, OPFS can contain `wp-runtime.json` with `initialOpfsSyncPending: true`, while `/wordpress` is only partly copied.

On the next page load, `opfsSiteStorage.list()` reads `wp-runtime.json` and adds the site to Redux. Before this PR, `bootSiteClient()` mounted that partial OPFS directory as `/wordpress` and tried to boot it. It would not boot because the initial sync never finished. The user saw a generic boot failure instead of an explanation that the browser-storage save was interrupted.

With this PR, `bootSiteClient()` stops before mounting `/wordpress` and shows “Browser storage save was interrupted.”

## Testing instructions

```bash
npm exec nx test playground-website
npm exec nx run playground-website:typecheck
npm exec nx run playground-website:lint
```
```

## Good: Stacked PR

```markdown
## What it does

Adds `createDecodedTarStream()`, a streaming codec layer that turns compressed TAR bundle bytes into a `ReadableStream<Uint8Array>` for `StreamingTarParser` from #123.

This PR adds the `zstddec` fallback needed for future `tar.zst` bundles. It does not switch any bundle URLs or boot paths to `tar.zst` yet.

## Rationale

The parser from #123 consumes plain TAR bytes. The bundle work needs to feed it `.tar.zst` bytes, but browser support for native `DecompressionStream('zstd')` is not universal.

Keeping this as a small follow-up makes the dependency and decoder behavior reviewable on their own before the PR that changes the actual bundle format.

## Implementation

`createDecodedTarStream(compressed, codec)` accepts either a `Uint8Array` or `ReadableStream<Uint8Array>`, uses native `DecompressionStream` when available, and falls back to `zstddec/stream` for `codec === 'zstd'`.

## Testing instructions

```bash
npm test -- streaming-tar-extract.spec.ts
npm run lint
npm run build
```

The zstd round-trip test generates its fixture only when the local runtime exposes zstd compression. Older runtimes skip that fixture generation while still building and typechecking the decoder path.
```

## Good: Bug Fix with Code

```markdown
## What it does

Fixes bookmark invalidation when the document changes between creating and seeking to a bookmark.

## Rationale

`Bookmark` stored direct references to `HTMLNode` objects. If you inserted text before the bookmark position, the node reference stayed valid but pointed to the wrong content.

```typescript
// Before: breaks when document is modified
class Bookmark {
  node: HTMLNode;
  constructor(node: HTMLNode) {
    this.node = node;
  }
}
```

## Implementation

Changed bookmarks to store character offsets instead of node references. When seeking, we walk the document from the start counting characters until reaching the offset.

```typescript
// After: resilient to document changes
class Bookmark {
  offset: number;
  constructor(doc: HTMLDocument, node: HTMLNode) {
    this.offset = doc.getCharacterOffset(node);
  }
  seek(doc: HTMLDocument): HTMLNode {
    return doc.getNodeAtOffset(this.offset);
  }
}
```

This matches how browser `Selection` APIs work.

## Testing instructions

Run `npm test -- bookmark.test.ts`. New tests cover creating a bookmark, inserting text before it, and seeking back to the bookmark.
```

## Good: Feature Addition

```markdown
## What it does

Adds `parseFragment()` for parsing HTML snippets without a full document context.

## Rationale

`parseDocument()` requires `<html>` and `<body>` tags. For HTML that will be inserted via `innerHTML`, such as `<tr><td>Cell</td></tr>`, we need fragment parsing that infers context.

## Implementation

`parseFragment(html, contextElement)` creates a temporary parsing context based on where the fragment will be inserted. For example, `<table>` uses “in table” mode and `<select>` uses “in select” mode.

## Testing instructions

```bash
npm test -- fragment-parser.test.ts
```

Tests cover `<tr>`, `<option>`, `<li>`, and `<td>` fragments and verify they are wrapped correctly.
```

## Bad: Generic AI Slop

```markdown
## Summary
This PR enhances the authentication system with improved session management capabilities and robust error handling mechanisms! 🚀

## Key Changes
- Enhanced token refresh functionality
- Improved navigation flow
- Better race condition handling
- Optimized user experience
- Added comprehensive error handling

## Technical Implementation
Leveraged modern authentication patterns to implement a scalable, enterprise-grade solution for token lifecycle management. The system now handles edge cases more effectively and provides enhanced reliability.

## Benefits
- Reduced session timeouts
- Better performance
- More robust authentication
- Enhanced security
- Improved developer experience

## Testing
- [ ] All tests pass
- [ ] Manual testing completed
- [ ] No regressions found

🤖 Generated with Claude Code
```

**Why it's bad:**
- No specific details about what changed
- Buzzwords: “enhanced,” “improved,” “robust,” “scalable,” “enterprise-grade”
- Emojis and bot signatures
- Bullets listing vague improvements
- No code examples or technical specifics
- Does not explain the actual problem or solution

# What to Avoid

**Don't:**
- Use emojis (🚀, 🎉, ✅)
- Write “enhanced,” “improved,” or “optimized” without specifics
- Use generic `## Summary` / `## Testing` when the default shape fits
- List files changed; the diff already shows files
- Add bot signatures
- Use corporate buzzwords: “leverage,” “synergy,” “robust,” “scalable,” “enterprise-grade”
- Write “key functionalities,” “core capabilities,” or “key improvements”
- Create bullet lists of vague changes
- Make every section 5+ paragraphs

**Do:**
- Use inline `code` for technical terms
- Show code examples for complex changes
- Explain **why** decisions were made
- Keep it scannable with formatting
- Focus on what matters
- Compare against the PR base branch, not the last commit
