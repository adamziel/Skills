---
name: llm-wiki
description: Use when creating, maintaining, querying, or linting a persistent LLM-maintained markdown wiki or knowledge base from raw sources. Covers source ingestion, wiki page updates, index/log maintenance, provenance, contradiction handling, and schema conventions. Based on Andrej Karpathy's LLM Wiki pattern.
---

# LLM Wiki

This skill turns a collection of raw sources into a persistent markdown wiki maintained by an LLM. It is based on Andrej Karpathy's LLM Wiki idea file: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f

The core pattern is:

- `raw/`: immutable source material. The LLM reads these files but does not edit them.
- `wiki/`: generated markdown pages. The LLM owns this layer and keeps it current.
- `AGENTS.md` or `CLAUDE.md`: the schema and operating manual for the wiki.
- `wiki/index.md`: content-oriented catalog of wiki pages.
- `wiki/log.md`: append-only chronological activity log.

Prefer the repo's existing layout if one exists. Only introduce this structure when setting up a new wiki.

## When To Use

Use this skill when the user wants to:

- create an LLM-maintained personal, research, project, business, course, or reading wiki
- ingest one or more sources into an existing wiki
- answer questions against a wiki with citations
- file a durable answer, analysis, comparison, or synthesis back into the wiki
- lint the wiki for contradictions, stale claims, orphan pages, missing links, missing provenance, or index/log drift
- design or update the wiki's schema instructions

Do not use this skill for a one-off summary where the user does not want a persistent knowledge base.

## First Pass

Before editing, inspect the repository:

```bash
rg --files
```

Look for an existing `raw/`, `sources/`, `wiki/`, `notes/`, `index.md`, `log.md`, `AGENTS.md`, or `CLAUDE.md`. Preserve existing conventions unless they make the task impossible.

If the wiki does not exist yet, create the smallest useful version:

```text
raw/
wiki/
  index.md
  log.md
  sources/
  concepts/
  entities/
  analyses/
AGENTS.md
```

Keep `AGENTS.md` concise. It should define page types, naming conventions, citation format, ingest/query/lint workflows, and what must not be edited.

## Ingest Workflow

When ingesting a source:

1. Preserve the source in `raw/` or use the existing raw-source location. Do not modify raw files.
2. Read the source and identify durable facts, claims, entities, concepts, dates, open questions, and contradictions.
3. Create or update a source summary page under `wiki/sources/`.
4. Update relevant entity, concept, timeline, and synthesis pages. A good ingest often touches multiple pages.
5. Record provenance near the claim, not only at the bottom of the page.
6. Update `wiki/index.md` with new and changed pages.
7. Append an entry to `wiki/log.md`.

Use stable, lowercase slug filenames such as `transformer-architecture.md`, `alice-smith.md`, or `2026-market-map.md`.

For source summary pages, use this shape unless the wiki already has a better convention:

```markdown
---
type: source
title: "Source title"
source: "path or URL"
added: YYYY-MM-DD
---

# Source title

## Summary

## Key Claims

## Entities And Concepts

## Connections

## Caveats

## Follow-Up Questions
```

## Query Workflow

When answering questions against the wiki:

1. Read `wiki/index.md` first.
2. Check `wiki/log.md` for recent ingests or changes that may affect the answer.
3. Search the wiki for relevant pages with `rg`.
4. Read the relevant pages and, when needed, the raw sources behind important claims.
5. Answer with citations to wiki pages and raw source paths/URLs.
6. If the answer is durable, ask whether to file it back into `wiki/analyses/` or do so directly when the user requested a persistent update.

Do not answer from memory when the wiki contains relevant material. Do not invent citations.

## Lint Workflow

A lint pass checks wiki health. Inspect for:

- contradictions between pages
- claims without source references
- stale claims superseded by newer sources
- pages missing from `wiki/index.md`
- index entries that point to missing pages
- orphan pages with no inbound links
- important concepts mentioned repeatedly but lacking their own page
- duplicate pages for the same entity or concept
- log entries missing for recent substantial changes

Make focused fixes directly when they are mechanical. For ambiguous contradictions, preserve both claims, cite both sources, and add a short "Tension" or "Contradiction" note instead of silently choosing one.

## Writing Rules

- Use concise markdown.
- Prefer cross-links over repeated explanations.
- Keep raw sources immutable.
- Keep summaries lossy but honest: preserve caveats, dates, minority views, and uncertainty.
- Keep provenance close to the claim it supports.
- Separate source facts from synthesis.
- Never erase a contradiction by smoothing it into a vague compromise.
- Append to `wiki/log.md`; do not rewrite history except to fix formatting.

## Log Format

Use a parseable heading format:

```markdown
## [YYYY-MM-DD] ingest | Source title

- Added: `wiki/sources/source-title.md`
- Updated: `wiki/concepts/example.md`, `wiki/index.md`
- Notes: one short sentence
```

Other operation names can include `query`, `lint`, `schema`, and `maintenance`.
