# Page templates — concrete and copy-pasteable

Each template here is something you can adapt directly. Placeholders use `{angle brackets}`. Italicized inline notes are guidance, not content to ship.

---

## 1. Tutorial chapter

Use this for any sequential learning material. Series of these = tutorial.

```markdown
# {Chapter title — verb-led, concrete. e.g., "Add a database to your app", not "Database integration"}

{One- or two-sentence framing. What this chapter does for the reader, in plain language.}

## You will learn

- How to {capability 1}
- How to {capability 2}
- How to {capability 3}
{3–5 bullets, all starting with "How to" or another verb. Keep them concrete.}

{Optional continuity opener if this is part of a series:}
> In the previous chapter, you {what they did}. Now you'll {what's next}.

## {First H2 — name the first concrete step or sub-goal}

{1–2 paragraphs setting up the problem this section solves. Why are we doing this? What's wrong without it?}

```{language}
// {filename}
{code}
```

{1–2 paragraphs after the code. What did this do? What's the new capability? If interactive: "Try changing X to Y."}

## {Second H2 — next sub-goal, builds on the first}

{Prose}

```{language}
// {filename}
{code, ideally a refinement of the previous code, with the diff highlighted via comments or a short prose pointer}
```

{Prose. Point at what changed and what's now possible.}

## Pitfalls

{Either inline Pitfall callouts after the relevant code, or a short subsection here. Each pitfall is the specific common mistake — not generic advice.}

> **Pitfall:** {The specific thing readers do wrong}. {What happens when they do it}. {The fix.}

## Recap

You can now:
- {Capability 1 — phrased as something the reader can DO}
- {Capability 2}
- {Capability 3}

{Optional: a 1-sentence framing of what's still missing — sets up the next chapter.}

---

→ **Next:** [{Chapter N+1 title}]({path}) — {one-sentence preview of the next chapter}
```

### Worked example

```markdown
# Add a route that returns JSON

You'll add a new HTTP route to your Hono app that returns a JSON response, and learn how Hono handles the request and response objects.

## You will learn

- How to define a GET route in Hono
- How to return JSON from a handler
- How the `Context` object exposes the request and response

> In the previous chapter, you scaffolded a Hono app that returns plain text. Now you'll add a real API endpoint.

## Add the route

A Hono app is a chain of route definitions. Each route ties a method and path to a handler function.

```ts
// src/index.ts
import { Hono } from 'hono'

const app = new Hono()

app.get('/users/:id', (c) => {
  const id = c.req.param('id')
  return c.json({ id, name: 'Ada Lovelace' })
})

export default app
```

`c` is the context — Hono's single-argument convention for accessing the request and building a response. `c.req.param('id')` reads the URL parameter; `c.json(...)` sets the right `Content-Type` and serializes for you.

## Run it

```bash
$ npm run dev
Listening on http://localhost:8787
```

Visit `http://localhost:8787/users/1`. You should see:

```json
{ "id": "1", "name": "Ada Lovelace" }
```

> **Pitfall:** Returning a plain object with `return { id }` instead of `c.json({ id })` won't work — Hono expects you to use the helpers because they set headers correctly.

## Recap

You can now:
- Define routes for any HTTP method and path
- Read URL parameters with `c.req.param`
- Return typed JSON responses with `c.json`

Your app currently has no validation or error handling. The next chapter adds both.

---

→ **Next:** [Validate inputs with Zod](./03-validation.md) — pair Hono's request parsing with schema-based validation
```

---

## 2. Concept guide

Use for explaining one idea at depth. Not part of a sequence.

```markdown
# {Concept name — noun. e.g., "Reactivity", not "Being reactive"}

{One-sentence definition. Should fit in a tweet. Quotable.}

{2–4 paragraphs of context: the problem this concept solves, where it fits, why it exists. Frame the importance before teaching the mechanic. (Solid's "Importance of X" pattern.)}

## A minimal example

{Smallest possible runnable code that shows the concept.}

```{language}
{code}
```

{Prose explaining each part. What does the reader need to notice?}

## {First refinement — adds one orthogonal capability}

{Prose framing what's new and why}

```{language}
{code — a refinement of the minimal example}
```

{Explain what changed. What does the new capability buy you?}

## {Second refinement}

{...same shape...}

## When to use this

{Bulleted list or short paragraphs. Concrete situations.}

## When not to use this

{Equally important. The praised docs always say where their thing is the wrong tool.}

## Pitfalls

> **Pitfall:** {specific mistake} — {what goes wrong} — {how to fix}

## See also

- **Reference:** [`{symbol}`]({path})
- **Tutorial:** [{tutorial chapter that introduces this}]({path})
- **Related concepts:** [{neighbor concept}]({path})
```

---

## 3. Quickstart

Use for the 5-minute path from nothing to working code. No detours.

```markdown
# Quickstart

By the end of this page, you'll have {concrete artifact: "a {X} server returning JSON", "a deployed {X} site", etc.}. {Time estimate: "About 5 minutes."}

## Install

{Tabbed code block — package managers OR per-OS, pick the relevant axis}

```bash
# npm
npm install {package}

# pnpm
pnpm add {package}

# bun
bun add {package}
```

## Create your first {thing}

```{language}
// {filename}
{complete, runnable code. 10–30 lines. Real, not toy.}
```

{2–3 sentences naming the moving parts. What's `app`? What's the handler? Just enough vocabulary to follow what's happening.}

## Run it

```bash
$ {single command}
{expected verbatim output}
```

Visit {URL}. You should see {what they should see}.

## What just happened

{Each paragraph names one piece of the example by file/line. Gives the reader a vocabulary to think about what they ran.}

- **{piece 1}:** {what it does, 1 sentence}
- **{piece 2}:** {what it does, 1 sentence}
- **{piece 3}:** {what it does, 1 sentence}

## Next steps

- → [Tutorial]({path}) — build a real app, step by step
- → [Concepts]({path}) — understand how it works
- → [Examples]({path}) — patterns and recipes
```

---

## 4. "Why X?" / Introduction

For the page that explains why this library exists.

```markdown
# Why {Project}?

{Optional opening with name etymology / pronunciation if it helps humanize. Vite does this: "Vite (French word for 'quick', pronounced /viːt/, like 'veet') is a build tool that…"}

## The origins

{The state of the world before this project. What was painful, what was missing, what couldn't you do? Tell it as a brief history. 1–3 paragraphs.}

## How {Project} solves it

{The core technical insight, plainly stated. One paragraph. No marketing — just the actual idea.}

## What this enables

{2–4 capabilities, each with a one-sentence example. Frame as outcomes the reader cares about, not features.}

- **{Outcome 1}** — {one-sentence example or comparison}
- **{Outcome 2}** — {...}
- **{Outcome 3}** — {...}

## How it compares

{Optional table or paragraphs. Honest about trade-offs. If your project isn't the right fit for case X, say so.}

| | {Project} | {Alternative A} | {Alternative B} |
|---|---|---|---|
| {dimension 1} | | | |
| {dimension 2} | | | |
| {dimension 3} | | | |

## Where {Project} is heading

{Optional. Brief, ≤2 paragraphs. Sets ongoing direction without making promises.}

## Get started

→ [Quickstart]({path}) — running code in 5 minutes
→ [Tutorial]({path}) — learn the full API by building something
```

---

## 5. Reference page (MDN / React shape)

For each public symbol. Even if your focus is tutorials, you'll cross-link to these.

```markdown
# {symbolName}

{One-sentence definition. Plain English. No jargon if avoidable.}

```{language}
{the canonical signature, 1–3 lines}
```

## Reference

### `{symbolName}({params})`

{2–3 sentences expanding the one-line definition. What does it do? When does it run? What's the contract?}

#### Parameters

- **`{param1}`**: `{type}`. {1-sentence description.} {If optional: "Defaults to `{default}`."}
- **`{param2}`**: `{type}`. {description.}

#### Returns

{type}. {1-sentence description of what's returned and when.}

#### Caveats

- {non-obvious behavior 1}
- {non-obvious behavior 2}

## Usage

### {Use case 1 — verb phrase, e.g., "Updating state based on the previous state"}

```{language}
{minimal example showing this use case}
```

{2–3 sentences explaining when and why you'd do this.}

### {Use case 2}

```{language}
{example}
```

{prose}

### {Use case 3}

{...}

## Troubleshooting

### {Common error or confusion 1, phrased as the reader would phrase it: "I've updated state but my logging shows the old value"}

{What's happening under the hood. What to do.}

### {Common error 2}

{...}

## See also

- **Concept:** [{concept page}]({path})
- **Related:** [`{related symbol}`]({path}), [`{related symbol}`]({path})
- **Tutorial:** [{chapter where this is introduced}]({path})
```

---

## 6. Examples / Recipes page

For one task in a cookbook. Recipes are browsed via search/grid; each one stands alone.

```markdown
# {Task — verb-led: "Return JSON", "Validate request bodies", "Stream a file"}

{2 sentences: when you'd do this, what tradeoff to know about.}

```{language}
// {filename}
{complete, copy-pasteable, realistic code}
```

{Optional: 2–3 sentence breakdown of any non-obvious lines.}

## See also

- **Recipe:** [{related task}]({path})
- **Concept:** [{relevant concept}]({path})
- **Reference:** [`{relevant symbol}`]({path})
```

---

## 7. Landing page (the docs index)

The page someone hits at `/docs` or `/`. Routes the reader to the right surface.

```markdown
# {Project} Documentation

{1–2 sentence project tagline — what is this thing, in plain language.}

## Get started

{Two large CTAs. Either by skill ("New here?" → tutorial; "Just looking up an API?" → reference) or by situation (Prisma's two-doors pattern). Pick one axis.}

> **New to {Project}?** → [Start the tutorial]({path})
>
> **Want to ship something now?** → [Quickstart]({path})

## Learn

- [Quickstart]({path}) — running code in 5 minutes
- [Tutorial]({path}) — build a real {X} step by step
- [Concepts]({path}) — understand how it works

## Reference

- [API reference]({path}) — every public symbol
- [CLI]({path})
- [Configuration]({path})

## Solve a specific problem

- [Examples]({path}) — patterns and recipes for common tasks
- [Migration guides]({path})
- [Deployment]({path})

## Community

- [GitHub]({url})
- [Discord]({url})
- [Contribute]({path})
```

---

## Composition rules across templates

When using these together to build a doc set:

- **Tutorial chapters** are sequenced. They share a single canonical project that grows. They link forward and back.
- **Concept guides** are atomic. Each stands alone. They link bidirectionally to reference.
- **Quickstart** appears once. It's the on-ramp before the tutorial. Don't confuse the two.
- **"Why X?"** appears once, on or near the introduction. It's persuasion + framing, not instruction.
- **Reference pages** are alphabetical-by-symbol within their package/module. They're not narrative.
- **Recipe pages** are browsed via search. Each is short and self-contained.
- **The landing page** is the only page that lists everything. Internal pages link laterally to specific neighbors, not back to the landing page.

If you find yourself writing a page that mixes templates (e.g., a tutorial chapter that drifts into reference material), split it. Mixed pages are the most common cause of doc bloat and the hardest to maintain.
