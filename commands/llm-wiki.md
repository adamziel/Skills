---
description: Create, maintain, query, or lint a persistent LLM-maintained markdown wiki from raw sources.
argument-hint: "[setup|ingest|query|lint plus source, topic, or question - optional]"
---

Invoke the `llm-wiki` skill on the task inferred from `$ARGUMENTS`.

- If `$ARGUMENTS` says `setup`, create or refine the minimal wiki structure and schema.
- If `$ARGUMENTS` says `ingest`, process the specified source(s), update relevant wiki pages, update the index, and append to the log.
- If `$ARGUMENTS` says `query`, answer from the wiki with citations, then file the answer back into the wiki if the user asked for a persistent artifact.
- If `$ARGUMENTS` says `lint`, check wiki health and make focused repairs where the fix is clear.
- If `$ARGUMENTS` is empty, inspect the current repo for an existing wiki and ask which operation to run.

Follow the skill's instructions exactly: preserve raw sources, keep provenance close to claims, maintain `wiki/index.md` and `wiki/log.md`, and preserve contradictions instead of smoothing them away.
