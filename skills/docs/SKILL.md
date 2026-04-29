---
name: docs
description: Use when writing onboarding documentation for a software library, framework, or developer tool — tutorials, conceptual guides, getting-started flows, and the surrounding learning surface. Specifically tuned for taking a developer from zero to productive familiarity, and for content that pairs prose with embedded interactive code examples (REPLs, sandboxes, live previews). Covers information architecture, concrete page templates, writing voice, example patterns, and how to integrate interactivity. Distilled from analysis of 21 highly-praised OSS docs sites (Svelte, Vue, React, Rust Book, FastAPI, Django, MDN, Tailwind, Astro, Next.js, Stripe-shaped Supabase, etc.).
---

# Library Onboarding Documentation

This skill encodes patterns from 21 OSS doc sites that developers consistently single out as best-in-class for onboarding (not just popularity — *praise specifically for documentation*). Use it when you're writing material that has to take a reader from "what is this" to "I can build with it."

The goal of onboarding docs is **familiarity**, not completeness. A reader who closes the page should be able to write something real and recognize the shape of the rest of the API. Reference docs serve a different purpose; they're covered here only at the boundary.

---

## When to use this skill

**Use it for:**
- Tutorials (sequential, narrative, build-something flows)
- Quickstarts (5–10 min from zero to running)
- Conceptual guides (explaining one idea at depth)
- "Why X?" / introduction pages
- Mixed onboarding sets that combine the above

**Don't use it for:**
- Pure API reference (use the MDN-shaped reference template at the bottom of `references/page-templates.md` and stop there)
- READMEs (different audience and length budget)
- Migration guides, changelogs, release notes
- Internal architecture docs

If the user asks for "documentation" without specifying, ask: *tutorial, conceptual guide, or reference?* The page templates differ.

---

## The three rules that override everything else

1. **The reader is intelligent and impatient.** They don't need to be sold. They don't need filler. They need to know what the thing is, why it's worth their time, and how to do something useful — fast. Praise consistently goes to docs that respect both halves: not condescending, not dense.

2. **Code-and-prose ratio is the master variable.** Every snippet should have just enough prose to explain *why* it exists and *what changed* from the previous one. Walls of code without prose teach nothing; walls of prose without code teach nothing. Aim for 1–4 short paragraphs around each substantive snippet.

3. **State your scope.** Praised docs explicitly say what they are and aren't (TypeScript Handbook lists non-goals; Django scopes the polls app upfront; React lists "You will learn" at the top of every page). Hidden scope is the #1 cause of reader frustration.

---

## Decision flow at the start of a docs task

Work through these in order before writing anything. Answer them out loud (in your reply, briefly) so the user can correct course.

### 1. Scope: how much are you writing?

| Scope | Approach |
|---|---|
| Single page (one tutorial, one concept) | Pick one of the page templates below. Skip IA decisions. |
| 3–10 pages (a small tutorial series or guide bundle) | Use the **Two-track lite** IA. One sequential tutorial, plus a few concept pages. |
| 10+ pages (a real onboarding surface) | Use **Diátaxis-influenced IA** (Tutorial / Concepts / Reference / How-to). Decide the IA *before* writing pages. |

### 2. Audience: who's reading?

Three personas shape every other decision:

- **The shipper.** Wants working code in 5 minutes. Skips concepts. Lands on quickstart, copy-pastes, moves on.
- **The learner.** Wants to understand. Reads the tutorial in order. Will follow a single canonical example across 10 chapters.
- **The integrator.** Has prior knowledge of similar tools, just needs to map their mental model to yours. Wants comparison tables, "coming from X" sections, idiom lists.

You're often writing for two of three. Decide which two and which is primary; design the entry point around the primary, but provide an obvious branch for the others. (TypeScript's intro routes by background; Vue's "Pick your learning path" does the same; Prisma's "two doors" routes by situation.)

### 3. Interactivity: what's available?

This shapes example design more than any other factor.

| Available | Implications |
|---|---|
| **In-page REPL/sandbox** (Svelte tutorial, React docs, TanStack Query StackBlitz) | Examples can be *runnable*. Prose can say "click run", "modify line 3". Cumulative state across pages becomes possible. |
| **Linked external playground** (Vue, Solid, Rust Playground) | Snippets are static in the docs, but every substantive one ends with "Try it in the Playground →". |
| **Live-rendered output** (Tailwind) | Visual examples can render inline as actual styled HTML. The doc *is* the demo. |
| **No interactivity, local-install only** (Astro, Next.js, Django, FastAPI) | The reader runs the app locally. The doc must give exact terminal output, exact URLs to visit, exact files to create. Be explicit about every command. |
| **Auto-generated docs from running app** (FastAPI's `/docs`) | The product's own UI *is* the playground. Onboarding can lean heavily on "now run it and play with the generated UI." |

State which environment your reader is in within the first 100 words of any tutorial. Don't make them guess.

### 4. Surface area: how big is the API?

| Surface | IA implication |
|---|---|
| Tiny (Zod-shaped, Hono-shaped, ~10–30 public symbols) | Skip the tutorial/reference split. A single long page or short guide-only set works. Zod's whole API is one scrollable page. |
| Medium (most libraries, ~50–200 symbols) | Standard split: tutorial → concept guides → grouped reference. |
| Massive (frameworks, runtimes) | Diátaxis tiers, with reference further sub-grouped by package/module. Tutorials carry one canonical project across many chapters. |

---

## Information architecture

Pick **one** of these shapes deliberately. Don't drift.

### A. Single linear book (Rust Book shape)

One artifact, top-to-bottom, sequential. Reference lives elsewhere as a separate destination.

**Use when:** the material has a strong narrative spine and the reader will benefit from reading top-to-bottom (a language tutorial, a framework's mental-model intro, a long-form course).

**Don't use when:** readers will land on individual pages from search and need self-contained context.

### B. Two-track (Learn + Reference)

Two top-level sections. `Learn` is sequential, narrative, one-canonical-example-grows. `Reference` is structural, alphabetical-by-symbol, examples-on-demand.

**Use when:** library is medium-sized and you have both new readers and returning lookups.

**Cross-link rules:**
- Concept pages link out to every reference symbol they mention.
- Reference pages link back to the concept page that introduces them, in a "See also" or sidebar callout.
- Reference pages should *not* re-teach concepts — they assume the concept page is the prerequisite.
- The new-user landing should default to Learn; experienced-user search should land in Reference.

This is the dominant pattern. Vue, React, Svelte, Solid, Next.js all use it.

### C. Diátaxis four-tier (Django/FastAPI shape)

Four explicit tiers, named on the landing page:
1. **Tutorials** — sequential, learning-oriented, "learn by doing"
2. **Concept Guides** (also called Topic Guides) — explanatory, "understand by reading"
3. **Reference** — structural, "look up by name"
4. **How-to Guides** (also called Recipes) — task-oriented, "solve a specific problem"

**Use when:** the library is large and the reader population is heterogeneous (beginners + production users + integrators all need different things).

**Watch out for:** the Tutorial/How-to boundary is the hardest. Tutorials teach concepts via building something; How-tos assume you know the concepts and just need to do a thing. If a page is both, split it.

### D. Two-doors fork (Prisma/Cloudflare shape)

The landing page presents two prominent CTAs that segment readers by their *situation*, not their skill level. Examples: "Use Prisma Postgres" vs "Bring your own database"; "Deploy a template" vs "Deploy with Wrangler CLI"; "I have an existing project" vs "Start from scratch."

**Use when:** there are two genuinely different starting situations that lead to different setup paths.

**Don't fake it.** Two doors that converge in three pages is just a fork; readers will resent it. Use only when the paths stay genuinely different for ≥5 pages.

### Sidebar ordering rules

Within whichever IA you pick:

- **Order by reader journey, not by importance to you.** What a beginner needs first goes first. Authentication is hugely important but it's almost never the first thing taught.
- **Group conceptually adjacent pages together.** Don't alphabetize the sidebar.
- **Use prerequisite-style ordering inside groups.** Each section assumes only what came before.
- **Keep the sidebar shallow.** Two levels of nesting maximum. Three is a sign the IA is wrong.
- **One page per concept.** Don't split a concept across pages because it's "too long" — long pages are fine if the right-rail TOC works. Splitting a concept across pages forces the reader to context-switch mid-thought.

---

## Page templates

Six templates cover most onboarding content. Use one, deliberately, per page. (Concrete copy-paste versions in `references/page-templates.md`.)

### 1. Tutorial chapter (Svelte/React/Astro shape)

The single most important template. Used for sequential learning material.

```
H1: Chapter title (verb-led, concrete)

[Optional: chapter-number breadcrumb if part of a series]

"You will learn":
- Bullet 1 (concrete, capability-shaped)
- Bullet 2
- Bullet 3
[3–5 bullets max. Verbs, not nouns.]

[Continuity opener if part of a series:]
"In the previous chapter, you [X]. Now we'll [Y]."

[1–2 paragraph context: WHY this chapter, what problem it solves]

H2: First concrete step

[Prose that names the goal]
[Code]
[Prose that explains what changed and why]
[If interactive: "Try modifying X to see Y."]

H2: Next concrete step
[...same shape...]

H2: Pitfalls / Common mistakes [optional but recommended]
[Each pitfall is a short subsection or a Pitfall callout anchored to specific code]

H2: Recap
- Bullet 1 (what the reader can now do)
- Bullet 2
- Bullet 3

---
[Forward link]: "Continue to Chapter N+1 →" with one-sentence preview of what's next
```

**Required elements:** "You will learn" at the top, "Recap" at the bottom, forward link to next chapter, every code block introduced with prose and followed with prose.

**Voice:** second person, occasional collaborative "we"/"let's", anticipate the reader's likely confusion.

### 2. Concept guide (Vue/Prisma/Solid shape)

For explaining one idea at depth. Not part of a sequence.

```
H1: Concept name (noun)

[1-line definition — quotable, copyable, fits in a tweet]
[2–4 paragraph context: what problem this concept solves, where it fits, why it matters]

H2: A minimal example
[The smallest possible runnable code that shows the concept]
[Prose explaining what each part does]

H2: [First refinement — adds one orthogonal capability]
[Code]
[Prose]

H2: [Second refinement]
[Code]
[Prose]

H2: When to use it / When not to use it [optional but valuable]

H2: Pitfalls / Common mistakes

H2: See also
- Reference: [link to the API page]
- Related concepts: [links]
- Tutorial: [link to where this concept is first introduced]
```

**Voice:** more explanatory than tutorial pages. "Importance of X" framing (Solid) works well — explicitly argue *why this matters before teaching it*. Anticipate the "but why?" question.

### 3. Quickstart (Hono/Bun/Vite/Cloudflare shape)

For a 5-minute path from nothing to working code. Distinct from Tutorial chapter 1 — quickstarts have no narrative, just steps.

```
H1: Quickstart [or "Get started in 5 minutes"]

[1-paragraph opener: what you'll have at the end. Concrete. "By the end of this page, you'll have a Hono server returning JSON from a route."]

H2: Install
[Tabbed code block: npm / pnpm / yarn / bun, OR per-OS if relevant]

H2: Create your first [thing]
[Code, ~10–30 lines, complete and runnable]
[2–3 sentences naming the moving parts]

H2: Run it
[Single command]
[Expected terminal output, verbatim, in a styled block]
[The URL to visit]

H2: What just happened
[2–4 short paragraphs that name each piece of the example by file and line — gives the reader a vocabulary]

H2: Next steps
- → Tutorial (for the long version)
- → Concept guides (for understanding)
- → Examples (for patterns)
```

**Required:** a working app that runs in under 5 minutes of reader time, no detours, no "but first, let's understand X" — concept-teaching belongs in the tutorial.

### 4. "Why X?" / Introduction (Vite shape)

For the page that explains why this library exists.

```
H1: Why [Project]?

[The Origins / The Problem]
[Narrative: what was the state of the world when this project started? What was painful?]

[How [Project] solves it]
[The core technical insight, plainly stated. One paragraph.]

[What this enables]
[2–4 capabilities, each with a one-sentence example or comparison]

[Where [Project] is heading]
[Brief, optional. Sets ongoing direction without making promises.]

[How it compares]
[Optional table or paragraphs. Honest about trade-offs.]
```

**Voice:** more narrative than other pages. Etymology/pronunciation of the name in the first sentence (Vite does this) humanizes the project. Avoid hype-superlatives; let the technical insight speak.

### 5. Reference page (MDN/React shape)

For the API surface. Even if you're focused on tutorials, you'll need these for cross-links.

```
H1: SymbolName

[1-sentence definition, plain English, no jargon if avoidable]

H2: Reference
  H3: Signature / Syntax
  [code: the type signature]
  H3: Parameters
  [list with types and one-line descriptions]
  H3: Returns
  [type and one-line description]
  H3: Caveats / Exceptions [if any]

H2: Usage
  H3: [Use case 1, named with a verb phrase]
  [Code + 2–3 sentences]
  H3: [Use case 2]
  [Code + 2–3 sentences]
  ...

H2: Troubleshooting [React signature move — adopt it]
  H3: [Common error or confusion 1]
  [What's happening, what to do]
  H3: [Common error 2]

H2: See also
- [Concept page that introduces this]
- [Related symbols]
```

**Voice:** drier than tutorial pages. Active, present tense. Short sentences. No personality — clarity is the personality.

### 6. Examples / Recipes page (Cloudflare/TanStack shape)

For the cookbook of "how do I X" patterns. Used for tasks the reader already understands but needs the canonical pattern for.

```
H1: [Task, verb-led]

[2-sentence context: when you'd do this, what tradeoff to know]

[Code: complete, copy-pasteable, realistic]

[Optional: 2–3 sentence breakdown of the non-obvious lines]

[See also: related recipes]
```

Recipes should be browsable as a grid (titled, searchable). They're not a sequence — readers land on one from search.

---

## Writing voice

The praised docs converge on a voice. It is not the only voice, but if you don't have a reason to deviate, default to this:

### Defaults

- **Second person.** "You" is the reader. "Your component", "your database". Default to this.
- **Collaborative "we" / "let's"** for steps the doc takes alongside the reader. "Let's add a route." "We'll use a function component here." Sparingly — every paragraph as "we" gets cloying.
- **Active voice, present tense.** "Vite resolves the import." Not: "The import is resolved by Vite."
- **Short sentences.** Aim for an average of 12–18 words. Long sentences are the #1 sign of a doc that wasn't edited.
- **Concrete verbs, concrete nouns.** "Click the Run button" beats "trigger execution." "Add a `name` field" beats "incorporate a designation."

### Patterns to adopt

- **Anticipate the reader's reaction.** Django's "*Wait a minute. `<Question: Question object (1)>` isn't a helpful representation.*" pattern. When the reader is about to be confused, name the confusion in their voice and resolve it.
- **State the why before the what** for non-obvious decisions. Vite's "Why Vite?", Solid's "Importance of X", Django's philosophy boxes. Half a paragraph of motivation makes readers tolerate two paragraphs of detail.
- **Anthropomorphize the tool sparingly.** "FastAPI is smart enough to notice…" works. "FastAPI loves to help you…" doesn't. Personality, not whimsy.
- **Address objections directly.** Tailwind's "*A common reaction to this approach is wondering, 'isn't this just inline styles?'*" — pre-empt the skeptic, don't pretend they aren't reading.
- **Use "Notice that…", "Here's…", "Note that…"** to point at specific lines. These are tiny but pull the reader's eye to where you want it.
- **Acknowledge difficulty when real.** "If this feels strange, you're not alone." (Rust Book on ownership.) Empathy works when the topic is genuinely hard. Don't fake it on easy material.

### Patterns to avoid

- **"In this section, we will explore…"** — kill these meta-sentences. Just explore.
- **"It is important to note that…"** — if it's important, just say it.
- **Hedging that isn't actually hedging.** "You might possibly want to perhaps consider…" → "Use this when X."
- **Marketing register inside technical material.** "Blazingly fast", "delightful DX", "best-in-class" inside a tutorial reads as cringey. Keep that on the landing page.
- **Tutorials in passive voice.** "The route is defined by the user." → "Define a route." Passive voice in instructional material is the most common voice failure.
- **Cleverness without payoff.** A joke that doesn't reinforce the engineering point is friction. Django's URL-encoding joke works because it makes a real point about URL design. Bunny puns about the project's logo do not.

### Worked transformation

Bad:
> In order to facilitate the proper handling of asynchronous operations within your application, it is generally recommended that developers consider the utilization of the `await` keyword in conjunction with functions that have been marked as `async`. This pattern, while initially perhaps somewhat unfamiliar, has become widely adopted across the JavaScript ecosystem.

Good:
> Mark a function `async` and you can `await` promises inside it:
>
> ```js
> async function getUser(id) {
>   const res = await fetch(`/users/${id}`)
>   return res.json()
> }
> ```
>
> `await` pauses the function until the promise resolves. The function itself returns a promise — so callers `await` it too.

Same content. Half the words. The good version puts code at the center; the prose serves the code.

---

## Examples and code

The single highest-leverage thing in onboarding docs is example craft. Get this right and the rest follows.

### Sizing

- **Smallest example that shows the concept.** Not the smallest possible — but no extra moving parts that don't teach.
- **Realistic enough to be recognizable.** A blog post, a user record, a todo, an HTTP route. Not `foo`/`bar`. Not deliberately abstract.
- **Don't be cute.** A `Cat` model in a tutorial about ORMs is fine. A `Cat extends Mammal` *cute* hierarchy that's actually about teaching inheritance is not — the reader is now learning the cat metaphor instead of the language.

### Framing

Two ways to introduce a code block. Both work; pick consciously:

- **Problem-first** (Rust Book, Django, Vite): name the problem, *then* show the code. Best for non-obvious solutions.
- **Code-first** (Hono, Bun, MDN reference): show the code, *then* explain. Best for familiar patterns where the reader can read code faster than prose.

Default to problem-first in tutorials, code-first in references.

### Patterns worth stealing

- **Output-as-comment** (Zod, MDN). Append the result inline:
  ```js
  z.string().parse("hello")
  // => "hello"
  ```
  This makes examples self-explaining without extra prose.

- **Errors-first** (Rust Book, TypeScript). Show the *broken* version, the actual compiler/runtime error verbatim, then the fix. Teaches the diagnostic path, not just the solution.

- **Listings with captions** (Rust Book). Number significant code blocks: "Listing 2-3: Comparing the guess to the secret number". Lets prose refer back without scrolling: "as in Listing 2-3, we…"

- **File-path labels** (Django, Vite, Bun, Next.js). Always label the file:
  ```
  // src/routes/index.ts
  export function GET() { ... }
  ```
  The reader needs to know where to put the code.

- **Single canonical example refined across chapters** (FastAPI's `read_item`). Don't introduce a new example every chapter. Take one example and refine it: add types, add validation, add error handling. The reader's mental model accumulates.

- **Single canonical app built across chapters** (Django polls, Next.js dashboard, Astro blog). The whole tutorial builds one real artifact. Each chapter's code is the previous chapter's code plus one capability. Cumulative.

- **Recap, step by step** (FastAPI). After showing 8 lines of code, re-present them as numbered single-concept items: "**Step 1:** Import `FastAPI`. **Step 2:** Create a `FastAPI` instance. ..." Each step gets one short paragraph. This is the strongest pattern for ensuring readers actually understood what they just saw.

### Anti-patterns

- **Examples that don't run.** If the reader copy-pastes, it works. Always. Pseudo-code belongs in concept docs, never in tutorials.
- **Examples that hide setup.** "Assuming you've installed X and configured Y…" — show that, or link to where it's shown.
- **Examples without the import line.** Always include the imports. The reader will copy this; they need to know where things come from.
- **Examples that change between snippets without saying so.** If line 3 changed, name it. Don't make the reader diff.
- **Long examples without diff highlighting.** When showing a refinement, show only the diff or use comments to mark the new lines (`// new`).

---

## Interactive code on the page

This is the user's specific need, so the rules go deeper here.

### What "interactive" means in practice

| Pattern | Examples | When to use |
|---|---|---|
| **Two-pane tutorial** (prose left, REPL right) | Svelte tutorial | Sequential learning where every step is a small modification to a running app. The strongest pattern for true zero-to-familiar. |
| **Embedded sandbox per page** | React, TanStack Query (StackBlitz) | Pages where you want one self-contained runnable demo per concept. Sandbox carries the example; prose narrates. |
| **Live-rendered output** | Tailwind | Visual concepts where the doc itself can render the result. Not a code editor — just live HTML. |
| **Linked external playground** | Vue, Solid, Rust | When embedding is technically hard. Every substantive example ends with a "Try it →" link. |
| **Progressive sandbox state** | Svelte tutorial (next exercise's starting code = previous exercise's solution) | Multi-page tutorials where you want the artifact to grow. The most demanding to author but the most rewarding to read. |

### Rules for prose-with-interactivity

When the snippet is interactive, prose changes. Different rules from static-snippet prose:

1. **Direct the reader's hand.** "Click the Run button." "Change line 4 to use `const`." "Notice the type tooltip when you hover `state`." This is rare in static docs and feels strange to write at first. Do it anyway — interactive examples reward action, and readers don't always realize they can act.

2. **Mark the modification clearly.** If the reader is supposed to change something, say what to change and what to expect. *"Change `count + 1` to `count + 2` and click Run. The number now jumps by 2."*

3. **Provide an escape hatch.** Svelte's "Solve" button. If the reader gets stuck, they can reveal the answer. Always include it for tutorials, even if it spoils the puzzle.

4. **Acknowledge the sandbox boundary.** "This sandbox runs in the browser; in production, you'd…" — readers will assume sandbox behavior is full behavior unless told otherwise.

5. **Resist over-engineering the sandbox.** A sandbox that needs 12 files to demonstrate a concept is a concept too big for one chapter. Split it.

6. **Cumulative state across pages is high-value but high-cost.** If you can preserve the reader's modifications from chapter to chapter (Svelte does this), do it. If you can't, at least pre-load each chapter's sandbox with the previous chapter's solution.

### When NOT to use interactivity

Counter-intuitively, sometimes static snippets are better:

- **Server-side / multi-process / database concepts.** A sandbox that mocks the database teaches the wrong thing. Static snippets + local-install is more honest.
- **Reference pages.** A reference page should be scannable. Sandboxes are heavy and slow scanning. Static snippets with output-as-comment are usually better.
- **Tiny concepts.** A two-line example doesn't need a sandbox. A code block with `// => "result"` is faster to read.

### Pairing prose with interactive code

Default structure for an interactive-example page section:

```
[H2 or H3 heading naming the concept]

[1–2 paragraphs of prose: what this is, why it matters]

[The interactive sandbox, pre-loaded with a runnable example]

[1–2 paragraphs after: what to notice, what to try modifying, what comes next]

[Optional: "Try this:" — one or two specific suggested modifications, each with a one-sentence expected result]
```

The "Try this:" pattern is gold. It converts passive readers into active ones. Use it.

---

## Callouts and recurring chrome

A small, named set of callout types reduces noise. Don't invent new ones page to page.

### Standard callout vocabulary

- **Note** — clarification, sidebar info, "by the way." Low importance.
- **Tip** — optimization or shortcut. The reader could skip it; they'd be slightly better off if they don't.
- **Warning** — non-obvious consequence the reader should know about. "If you do X, Y will fail."
- **Pitfall** — the specific common mistake the reader is about to make. Anchored to specific code, not general. (React's signature move; copy it.)
- **Deep Dive** (collapsible) — optional, advanced detail that breaks tutorial flow. Hide it by default.
- **See also** — cross-references at the end of a section.
- **Check / Try this** — invitation to act on an interactive example.

That's seven. Resist adding an eighth.

### Where callouts go

- **Pitfall** anchored immediately *after* the code that the pitfall is about. Not in a "Common Mistakes" section at the bottom.
- **Note** wherever clarification is needed.
- **Warning** before the code that triggers the warning's condition.
- **Tip** after the basic version, before the next section.
- **Deep Dive** at the end of the section, collapsed.
- **See also** at the end of the page (or section, for long pages).

### Required chrome elements

Every page should have:

- **A clear H1** that's verb-led for tutorials, noun-led for references.
- **A 1–3 sentence lead** under the H1 — the page's elevator pitch.
- **An "On this page" TOC** for any page longer than ~600 words.
- **Forward and backward links** at the bottom for sequential content. ("← Previous: X" / "Next: Y →")
- **An "Edit this page" link** if the docs are open-source.
- **A "Last updated" timestamp** for reference pages.
- **A markdown source link** (`/page.md` or `/llms.txt`) for LLM-friendly access. This is now table stakes; React, Vue, Astro, Bun, Next.js all do it.

---

## Pre-flight checklist

Before declaring a page or set of pages done, verify:

- [ ] **Scope is stated.** The reader knows what they will and will not learn.
- [ ] **Every code block is preceded by prose** that names what it does and why it's there.
- [ ] **Every code block is followed by prose** that points at what changed or what to notice.
- [ ] **Every example runs as written.** Including imports. Including setup.
- [ ] **File paths are labeled** on every code block that lives in a project.
- [ ] **Forward links** at the end of sequential pages point to the next chapter with one sentence of preview.
- [ ] **Cross-links to reference** appear wherever a symbol is mentioned.
- [ ] **Pitfalls** are surfaced where readers actually trip, not at the bottom of the page.
- [ ] **The first hands-on action** happens within the first 200 words for tutorials, first 500 for concept guides.
- [ ] **Voice is second-person, active, present tense** throughout. No passive-voice drift.
- [ ] **No filler sentences.** ("In this section, we will explore…", "It is important to note…")
- [ ] **Recap section** at the end of tutorial chapters listing what the reader can now do.
- [ ] **For interactive pages:** a "Try this" suggestion exists, an escape hatch exists, sandbox boundaries are stated.

---

## Anti-patterns to never ship

A short list of patterns that consistently appear in *bad* docs and never in praised ones:

1. **The wall of intro.** Five paragraphs of marketing before any code. The reader scrolls past it; you've trained them to skip your prose.
2. **The mystery import.** A code example that uses `getThing()` without showing where `getThing` came from.
3. **The bait-and-switch tutorial.** Chapters 1–3 are gentle; chapter 4 abruptly assumes Kubernetes knowledge. Audience must stay consistent.
4. **The phantom prerequisite.** "First, configure your environment." (No link, no instructions.)
5. **The dead-end page.** A page with no forward link, no "see also", no clear next step. Readers don't know if they're done or lost.
6. **The everything page.** A 12,000-word page covering setup, concepts, API, examples, and migration. Split it.
7. **The undated page.** No "last updated" timestamp on a tutorial that mentions a specific version. Readers can't tell if it's current.
8. **The toy-example tutorial.** The whole tutorial uses `foo`/`bar`. The reader finishes without ever seeing what real code with this library looks like.
9. **The non-example example.** "Imagine you have a function that fetches data…" — show the function, don't imagine it.
10. **The buried CTA.** The actual "do this now" is in paragraph six. Praised docs put the action up front.

---

## Process when starting

When the user gives you a docs task:

1. **Acknowledge the scope** in your reply (one tutorial chapter? a whole onboarding set?).
2. **Ask the four decision-flow questions above** if not already obvious from context.
3. **Pick the IA shape** if it's a multi-page set, and confirm with the user before writing pages.
4. **Pick the page template** for the page you're about to write.
5. **Sketch the outline first** — H1, "You will learn" bullets, H2s, "Recap" — and confirm with the user before drafting prose. This is the highest-leverage moment for course correction.
6. **Draft the page** following the template.
7. **Run the pre-flight checklist** before declaring done.

For substantial doc sets, work one page at a time and confirm direction after page 1 — the patterns established in page 1 propagate, and a wrong template choice early is expensive.

---

## Reference files

- **`references/page-templates.md`** — concrete copy-pasteable templates for each page type, with placeholder text and worked examples.
- **`references/source-projects.md`** — distilled notes on each of the 21 source projects analyzed. Use as inspiration when writing for a project that resembles one of them in shape (e.g., writing docs for an ORM → Prisma; for a runtime → Bun/Deno; for a UI library → React/Svelte; for a small validation lib → Zod).

Don't read these files preemptively. Pull them in when relevant to the specific task.
