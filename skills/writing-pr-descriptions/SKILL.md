---
name: writing-pr-descriptions
description: Writes clear, punchy, human-oriented PR descriptions that focus on what matters.
---

When writing PR descriptions, be concise and structured. Write the right things, not a lot of things.

# Process

Before writing, compare the branch against the PR base branch (not just the last commit):

```bash
git diff <base>...HEAD
git log <base>...HEAD --oneline
```

Use `trunk` or `main` as appropriate for the repo. This shows the full scope of changes.

# Default Structure

Use these four sections, in this order:

## What it does
## Rationale
## Implementation
## Testing instructions

Keep each section focused. This is the default PR description style unless the user explicitly asks for a different format.

# Section Guidance

## What it does

Say what behavior, API, invariant, or workflow changed. Mention important non-goals when they prevent reviewer confusion, especially in stacked PRs.

## Rationale

Explain why the change exists and why this PR is shaped this way. For stacked PRs, explain what this PR adds on top of the previous PR and what remains for later PRs.

## Implementation

Summarize the mechanism at the right level. Use a short numbered list when the flow matters. Include a tiny code example only when it clarifies a non-obvious design.

## Testing instructions

List concrete commands and manual checks. Prefer exact commands in a fenced code block. Add any caveats such as version-gated tests or skipped fixtures.

# Writing Guidelines

**PR titles:** Never start PR titles with `[codex]`, `Codex:`, or any AI/tool label. Never add Codex/OpenAI co-author trailers or AI disclosure boilerplate to PR descriptions.

**Be specific.** Use inline code for technical terms: `TokenRefresher`, `SESSION_TIMEOUT`, `/api/v2/auth`.

**Be concise.** Every sentence should add new information. Cut the fluff.

**Use formatting.** `code`, **bold**, _emphasis_, and code blocks make descriptions scannable.

**Show, don't tell.** Code examples beat vague descriptions.

**Avoid file-by-file changelogs.** The diff already shows files. Explain the product or technical change instead.

# Examples

## Good: Focused and Structured

```markdown
## What it does

Prevents users from getting logged out mid-navigation. The `TokenRefresher` now blocks route transitions until any in-flight token refresh completes.

## Rationale

Token expiration and navigation could race. If your token expired at `t=0`, navigation started at `t=10ms`, refresh completed at `t=150ms`, the API call would use the expired token and redirect to login mid-flow.

## Implementation

Added `waitForRefresh()` to `NavigationGuard`. When navigation starts:
1. Check if `TokenRefresher.isRefreshing`
2. If true, await the refresh promise (max 200ms)
3. Proceed with fresh token

```typescript
async canActivate(): Promise<boolean> {
  if (this.tokenRefresher.isRefreshing) {
    await this.tokenRefresher.currentRefresh;
  }
  return this.auth.isAuthenticated();
}
```

Considered making API calls retry with new tokens instead, but that's complex for non-idempotent requests.

## Testing instructions

1. Set `SESSION_TIMEOUT=30` in `.env.local`
2. Wait 25 seconds, then navigate between routes rapidly
3. Verify no login redirects occur
4. Check network tab shows refresh completing before route API calls
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

`createDecodedTarStream(compressed, codec)`:

1. Accepts either a `Uint8Array` or `ReadableStream<Uint8Array>`.
2. Uses native `DecompressionStream` when the runtime supports the requested codec.
3. Falls back to `zstddec/stream` for `codec === 'zstd'`.
4. Propagates decoder failures through the returned stream.

The fallback feeds compressed chunks into `ZSTDDecoder.decodeStreaming()` and emits decoded TAR chunks without materializing the full decompressed archive in JS.

Related: #456

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

Run `npm test -- bookmark.test.ts`. New tests cover:
- Creating bookmark, inserting text before it, seeking to bookmark
- Multiple bookmarks in same document
- Bookmarks across element boundaries
```

## Good: Feature Addition

```markdown
## What it does

Adds `parseFragment()` for parsing HTML snippets without a full document context.

## Rationale

`parseDocument()` requires `<html>` and `<body>` tags. For parsing HTML that will be inserted via `innerHTML` (like `<tr><td>Cell</td></tr>`), we need fragment parsing that infers context.

## Implementation

Added `parseFragment(html, contextElement)` that creates a temporary parsing context based on where the fragment will be inserted:

- Context is `<table>` → use "in table" mode
- Context is `<div>` → use "in body" mode
- Context is `<select>` → use "in select" mode

Special handling for orphaned elements like `<tr>` or `<option>` that are only valid inside specific parents:

```typescript
if (isOrphanedTableRow(fragment)) {
  return parseFragment(fragment, document.createElement('tbody'));
}
```

This matches the HTML5 fragment parsing algorithm.

## Testing instructions

```bash
npm test -- fragment-parser.test.ts
```

Tests cover `<tr>`, `<option>`, `<li>`, `<td>` fragments and verify they're wrapped correctly.
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
- Buzzwords: "enhanced," "improved," "robust," "scalable," "enterprise-grade"
- Emojis and bot signatures
- Bullets listing vague improvements
- No code examples or technical specifics
- Doesn't explain the actual problem or solution

# What to Avoid

**Don't:**
- Use emojis (🚀, 🎉, ✅)
- Write "enhanced," "improved," "optimized" without specifics
- Use generic `## Summary` / `## Testing` when the four-section structure fits
- List files changed (that's what the diff shows)
- Add bot signatures
- Use corporate buzzwords: "leverage," "synergy," "robust," "scalable," "enterprise-grade"
- Write "key functionalities," "core capabilities," "key improvements"
- Create bullet lists of vague changes
- Make every section 5+ paragraphs

**Do:**
- Use inline `code` for technical terms
- Show code examples for complex changes
- Explain **why** decisions were made
- Keep it scannable with formatting
- Focus on what matters
- Compare against the PR base branch, not the last commit
