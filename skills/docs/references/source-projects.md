# Source projects — what each one does well

Distilled notes on the 21 OSS docs sites this skill is built from. When writing docs for a project that resembles one of these in shape, pull the matching notes. Each entry calls out the project's signature moves so you can adapt them.

The projects are grouped by problem-shape, not alphabetically.

---

## Frameworks with two-pane interactive tutorials

These projects' onboarding centerpiece is a Svelte-style split-screen REPL. Adopt their patterns when you have a real interactive sandbox available.

### Svelte (svelte.dev/tutorial)

The most-copied tutorial pattern in the industry: prose left, REPL right, exercises chained so each starts where the previous ended.

**Signature moves:**
- Cumulative state across exercises — the tutorial builds *one continuous mental model*, not 30 toy snippets.
- A `solve` button as a low-friction escape hatch when stuck.
- Tutorial treated as the *primary* learning surface; reference defers to it for newcomers ("If you're new to Svelte, we recommend starting with the interactive tutorial").
- Curriculum stacked into four tracks: **Basic Svelte → Advanced Svelte → Basic SvelteKit → Advanced SvelteKit** — readers move down the stack.
- Vim mode toggle, file tabs, console — the REPL feels like a real editor.

**Steal:** the layout, the cumulative-state pattern, the "tutorial is canonical, reference is for lookups" framing.

### Vue.js (vuejs.org)

Cleaner than Svelte's IA, more conservative interactivity. Vue's guide is the spiritual ancestor of the modern framework-docs template.

**Signature moves:**
- **API Preference toggle** (Options/Composition) at the top of the sidebar; pages dynamically swap content based on the persisted choice. The cleanest solution to "we have two paradigms, both must be first-class."
- "Pick Your Learning Path" section on the Introduction page explicitly enumerating three on-ramps (interactive tutorial / examples / read the guide).
- "Try it in the Playground" links from substantive snippets, opening the SFC Playground in a new tab.
- "See also" sections used systematically to cross-link guide ↔ API.
- LLM-friendly Markdown mirrors of every page, advertised in a banner.

**Steal:** the persistent paradigm-toggle pattern when teaching two ways to do the thing; the explicit "pick your path" routing on the introduction.

### React (react.dev)

The 2023 react.dev rewrite is the most universally praised docs rewrite of the past five years.

**Signature moves:**
- **"You will learn"** bullet list at the top of every Learn page. The single most-copied React-docs pattern. Adopt it as a default for tutorial chapters.
- **Pitfall callouts** anchored to specific code, not collected in a "Common Mistakes" footer.
- **Deep Dive** collapsible sections — optional advanced material hidden from beginners by default.
- **Troubleshooting** as a first-class section in API references, listing problems users actually hit ("I've updated state but logging gives me the old value").
- **Numbered Example carousels** — pick example 1/2/3/4 from a tab strip on a single page.
- "What the browser sees" comparisons that show generated HTML next to JSX.
- Embedded sandbox per concept on every Learn page (forked CodeSandbox).
- Charming concrete examples (NASA scientists as Profile components — beats `Foo`/`Bar`).

**Steal:** "You will learn" bullets, Pitfall callouts, Deep Dive collapsibles, Troubleshooting sections in references, sandboxes-per-concept.

### Solid (docs.solidjs.com)

Smaller, cleaner-than-Qwik community rewrite. Concept-page craft is the strength.

**Signature moves:**
- **"Importance of X"** framing on concept pages — explicitly arguing why a concept matters before teaching it.
- Eraser.io diagrams linked from concept pages for visual learners.
- Concepts sidebar walks reactivity bottom-up (Signals → Effects → Stores) instead of starting with components — matches Solid's philosophical priorities.
- "Edit this page" / "Report an issue" prominent on every page, encouraging community fixes.

**Steal:** the "Importance of X" pattern when teaching a concept the reader doesn't yet know they need.

---

## Frameworks with cumulative-project tutorials

These projects don't embed REPLs but commit to building one real artifact across many chapters. Adopt their patterns when interactivity isn't an option.

### Astro (docs.astro.build)

The "Build a Blog" tutorial structured as numbered Units with checkbox progress.

**Signature moves:**
- Tutorial structured as **numbered "Units"** (Unit 0 → 1 → 2 → ...) with persistent checkbox progress and "To-do 1, To-do 2" markers — feels like a workbook.
- "Check in: Unit X" review pages between units.
- Playful section headings ("Set sail for Astro islands", "Back on dry land. Take your blog from day to night, no island required!").
- "If you got lost, here's where we are" reset points after each unit.
- Hyper-comprehensive third-party integration coverage — Astro effectively documents the entire ecosystem in-tree.
- Multilingual i18n with prominent language switcher.
- `llms.txt` and `.md` mirror routes for every page.

**Steal:** the workbook-with-checkboxes structure for long-form tutorials, the "where we are" reset points.

### Next.js Learn (nextjs.org/learn)

The 16-chapter "build a dashboard app" course is the praised piece. (Reference docs are mixed in reputation.)

**Signature moves:**
- **Two-track approach** — separate `/docs` (reference + guides) and `/learn` (course) — with the course building one complete product end-to-end.
- **Progress sync** if logged in, **end-of-chapter quizzes** — turns docs into a MOOC.
- **App Router / Pages Router toggle** at the top of the docs sidebar.
- "You've Completed Chapter X — Congratulations!" completion banners with recap.
- "Next Up" cards pointing to the next chapter, with one-sentence preview.
- Per-page Markdown mirrors for LLMs; "Last updated" timestamps on every reference page.
- File-path-labeled code blocks (`/app/lib/placeholder-data.ts`).

**Steal:** the "you've completed chapter X" + recap + next-up pattern; the cumulative-product approach for long tutorials.

### Django (docs.djangoproject.com)

The 7-part "Writing your first Django app" polls tutorial. The classic.

**Signature moves:**
- **Project-first scoping**: chapter 1 opens by stating exactly what the reader will build ("a public site that lets people view polls and vote in them; an admin site that lets you add, change, and delete polls").
- **Continuity ritual at chapter boundaries**: every chapter opens with "this tutorial begins where Tutorial X left off" and closes with "when you're comfortable, read part N+1."
- **Philosophy boxes** mid-tutorial that explain *why* certain decisions were made ("Why a helper function? Because that would couple the model layer to the view layer…").
- **Reader-voice anticipation**: "Wait a minute. `<Question: Question object (1)>` isn't a helpful representation of this object. Let's fix that…"
- **Witty asides** that stay relevant — humor used to make a real engineering point.
- **Diátaxis adherence** — the four tiers (Tutorials/Topics/Reference/How-to) named explicitly on the landing page.

**Steal:** project-first scoping, continuity ritual, philosophy boxes, reader-voice anticipation. Don't fake the wit — Django's works because the writers are funny.

### FastAPI (fastapi.tiangolo.com)

The strongest example of progressive disclosure in OSS docs.

**Signature moves:**
- **The "Recap, step by step"** pattern — after showing 8 lines of code, re-present them as numbered single-concept steps with one-paragraph-per-step. Each line gets a heading.
- **One example, refined across many chapters** — same `read_item` function evolves over 10+ pages, each adding one concept. Not "here's a new example" but "here's the same example, refined."
- **Auto-generated `/docs` as the playground** — the running app's Swagger UI is the interactive teaching surface.
- **Anthropomorphic framing** ("FastAPI is smart enough to notice…") — the framework is treated as a helpful character.
- **Tutorial that explicitly serves as future reference** is a stated design goal.
- Inline `Check:` callouts (validate something works), `Tip:` callouts, `Note:` callouts, `Info:` callouts.

**Steal:** "Recap, step by step", single-example-refined pattern, the running-app-as-playground when applicable.

---

## Single-linear-book onboarding

### Rust Book (doc.rust-lang.org/book)

The book *is* the tutorial. 20 chapters, sequential.

**Signature moves:**
- **Two-pass pedagogy**: Chapter 2 immerses the reader in a real program (the guessing game) using ten concepts they don't yet understand, then Chapters 3–4 retroactively formalize them. This is unusual — most docs go formal-then-applied.
- **Reproducing actual compiler errors verbatim** as a teaching tool.
- **Listings** with formal numbering and captions (`Listing 2-1: Code that gets a guess from the user and prints it`) — the prose can refer back without scrolling.
- **Foreword as ethos statement** before any code.
- Explicit forward references inside chapters: "Chapter 10 will cover traits in detail."

**Steal:** errors-first teaching, listings with captions, the two-pass approach when the topic is genuinely hard and a brief immersion before formalization helps motivation.

### TypeScript Handbook (typescriptlang.org/docs/handbook)

A linear handbook + non-sequential reference files. Praised for clarity.

**Signature moves:**
- **Audience-routing intro** that branches readers by background (no-programming → external JS tutorial; other-language → "you can pick up JS quickly"; JS already → skip).
- **Explicit non-goals** on the intro page — saying what *won't* be taught is rare and disarming.
- **Linear concept-builds-on-concept ordering** is a stated, public design constraint.
- **Inline rendered error messages with squiggles** in code samples — the docs show what the IDE will show.
- Every substantial code block has a `[Try]` link that opens the TypeScript Playground with that code pre-loaded.
- Error-driven framing: a problem version that errors → the actual TS error message → corrected version.

**Steal:** the audience-routing intro pattern, explicit non-goals, error-driven example framing.

---

## Tools and runtimes (mid-IA, code-first)

### Vite (vitejs.dev)

Praised for an unusually narrative "Why Vite?" page.

**Signature moves:**
- **"Why Vite?" with chapter-named subsections** ("The Origins", "Growing with the Ecosystem", "A Unified Toolchain", "Where Vite is Heading") — most docs skip the why or shove it into a paragraph.
- **Etymology + pronunciation** in the very first sentence ("Vite (French word for 'quick', pronounced /viːt/, like 'veet')") — humanizes the tool.
- **StackBlitz "Try Vite online"** as the no-install on-ramp.
- Problem-solution framing throughout — sections open by stating the problem before the solution.
- Three callout types only: NOTE, WARNING, TIP.

**Steal:** the "Why X?" structure with named chapters; etymology/pronunciation if it humanizes the name.

### Bun (bun.sh/docs)

Marketing-fluent voice in technical docs.

**Signature moves:**
- **Stated section-template** ("overview / quick examples / reference / best practices") published on the landing page itself — Bun publishes its own page-shape rule.
- **`<Steps>` + `<Tabs>` componentry** doing heavy lifting for procedural cross-platform content.
- **Confident, marketing-fluent voice** ("the last `npm` command you'll ever need") that's polarizing but consistent.
- Per-page italicized one-line summary under the H1, reading like a callout.
- `llms.txt` index explicitly designed for LLM consumption.
- Card-driven landing page reflecting the four-tool identity (Runtime / Package Manager / Test Runner / Bundler).

**Steal:** the stated-page-shape rule, the Steps+Tabs pattern for procedural content. The marketing voice is genre-specific — adopt only if it fits the project.

### Deno (docs.deno.com)

Functional, careful, less personality.

**Signature moves:**
- **Per-OS tabs everywhere** for install commands.
- **Per-page feedback widget** ("Did you find what you needed?" with text comment).
- **Explicit categorization of API surface** by origin (Deno-specific / Web-standard / Node-compat) — pedagogically signals "this is portable" vs "this is ours."
- Bold differentiator opening sentences ("TypeScript is a first class language in Deno. You can run or import TypeScript without installing anything more than the Deno CLI.").

**Steal:** API categorization by origin (when relevant), per-page feedback widget.

### Hono (hono.dev)

Code-first homepage. Compact docs reflect a small surface area.

**Signature moves:**
- **Code-first homepage** that drops a working `c.text("Hello Hono!")` example above the fold.
- **Cross-runtime tabs as a documentation primitive** — same example shown for Node/Bun/Deno/Cloudflare Workers, in the same tab block, throughout.
- **Honest benchmark tables in concept docs**, not just on a marketing page.
- **`twoslash` TypeScript blocks** that make hover-types visible in rendered docs.
- "We" voice that reads like pair-programming ("**We** can set up the project, write code, develop with a local server").

**Steal:** code-first opener, cross-runtime tabs when your library spans runtimes, twoslash for type-aware code.

---

## Library docs (small surface, mega-reference)

### Zod (zod.dev)

The single-page mega-reference, used because the API is shallow-but-wide.

**Signature moves:**
- **Single-page mega-reference**: `/api` is one massive scrollable document with sticky right-side TOC, organized by schema type (`z.string()`, `z.object()`, `z.union()`...).
- **Concept-first homepage**: tagline → feature bullets → canonical example → installation, in that order.
- **Output-as-comment** (`// => { name: "Ada" }`) used consistently to make examples self-explaining.
- **Zod / Zod Mini code-switcher** — readers can swap the entire example to the tree-shakeable variant without leaving the page.
- Casual voice for a reference (emoji, parentheticals) paired with terse prose.

**Steal:** the single-page mega-reference when your API is small (≤30 public symbols), output-as-comment everywhere, the variant-switcher pattern when you have build-time variants.

---

## Library docs (mid surface, classic Diátaxis)

### Prisma (prisma.io/docs)

Tight Concept-Guide ↔ Reference discipline.

**Signature moves:**
- **"Two doors" framing** on the landing page that segments users by *situation*: "Use Prisma Postgres" vs "Bring your own database".
- **Tight discipline between Concept Guides and Reference**: the guide tells you *why relations exist*, the reference page tells you *every option `include` accepts* — bidirectional cross-links.
- Framework-specific quickstarts as the actual on-ramp rather than a generic one.
- Recurring blogging-platform schema (User/Post/Comment/Tag) anchors conceptual docs as a familiar example.

**Steal:** the two-doors situation-routing, the strict guide/reference boundary, the recurring canonical schema.

### TanStack Query (tanstack.com/query)

Persuasion-first overview, recipe-driven examples.

**Signature moves:**
- **Persuasion-first overview**: motivation and problem framing precede any code, with self-aware section titles like "Enough talk, show me some code already!" and "You talked me into it, so what now?"
- **Reference deliberately separated from examples** — the `useQuery` page is structurally complete but example-free; the Examples section carries that weight via embedded StackBlitz iframes.
- **StackBlitz embeds** on every example page — title → context → full StackBlitz iframe → link to source.
- **Multi-framework parity** in nav (React/Vue/Solid/Svelte/Angular) without forking content.
- Self-deprecating humor that validates reader pain ("If you're not overwhelmed… you deserve an award").

**Steal:** the reference-without-examples + examples-with-runnable-embeds split; persuasion-first overview when readers might not yet care.

---

## Platform / mega-IA

### Cloudflare Workers (developers.cloudflare.com/workers)

Tutorial / Examples / Reference triad maintained as truly separate sections.

**Signature moves:**
- **Tutorial / Example / Reference triad** as separate top-level sections — many sites nominally have this, Cloudflare actually maintains the boundaries. Tutorials are end-to-end ("build a Slackbot"), Examples are pattern-recipes ("Return JSON"), Reference is API surface.
- **Filterable Examples grid** with action-verb titles ("Return JSON", "Fetch HTML", "Redirect requests"), treating examples as a searchable cookbook.
- **Inline anticipated-failure callouts** ("Browser issues?", "No visible changes?") in the getting-started flow — anticipates common trip points exactly where they happen.
- **Two-doors landing CTAs**: "Deploy a template" vs "Deploy with Wrangler CLI".
- `llms.txt` markdown index of the entire docs.

**Steal:** the strict triad with separate top-level sections; the action-verb filterable examples grid; anticipated-failure inline callouts.

### Supabase (supabase.com/docs)

The closest thing in OSS to Stripe-style polish.

**Signature moves:**
- **Three-column Stripe-style reference layout**: left = full API tree, middle = prose with parameters/required tags/descriptions, right = code panel with language tabs (JS/Dart/Swift/Kotlin/Python) and example output JSON.
- **One canonical sample app ("user management") rebuilt across every web framework** — when readers compare frameworks, they're comparing the same feature set.
- **Massive framework-tile breadth** at the entry point (13+ framework quickstarts).
- **AI-prompt-pack** as a documented onboarding mechanism — explicitly publishes prompts users can paste into Cursor/Claude.
- Definitional clarity over wit ("Authentication means checking that a user is who they say they are. Authorization means checking what resources a user is allowed to access.").

**Steal:** three-column reference layout when your API has multi-language SDKs; one-canonical-app-across-frameworks when you support many integrations.

### MDN Web Docs (developer.mozilla.org)

The reference standard the rest of the industry borrows from.

**Signature moves:**
- **The MDN reference template** — Syntax / Parameters / Return value / Exceptions / Examples / Specifications / Browser compatibility / See also — adopted as a de facto template by many other projects. If you're writing reference, this is the default shape.
- **Browser Compatibility Data (BCD) tables** — per-browser version support, expandable. Unique data asset.
- **Bidirectional Guide ↔ Reference linking** — Guide pages link out to every reference symbol they mention; reference pages link back to the relevant Guide.
- **Glossary** as a separate top-level concept-definition layer.
- **Per-page "Last modified" timestamp + GitHub edit link**.
- **Interactive Example widget** at the top of many JS reference pages — embedded code editor, edit and run inline. Not on every page; standard on most JS built-ins.
- Voice is **minimal, professional, no personality** — and that's the point. Clarity is the personality.

**Steal:** the reference template (use it as your default reference shape), the Glossary as a separate layer, the bidirectional guide-reference linking.

### Tailwind CSS (tailwindcss.com/docs)

Reference-as-tutorial. The API is small enough that browsing is the learning.

**Signature moves:**
- **The Quick reference table** at the top of every utility page — a tiny per-page cheat sheet summarizing the API.
- **Live-rendered visual examples for every utility class** — reading the docs is reading a styled site. The doc *is* the demo.
- **"Why not just X?" rhetorical sections** that pre-empt skepticism ("A common reaction to this approach is wondering, 'isn't this just inline styles?'").
- **The complete absence of a tutorial** — the docs argue that the reference *is* the tutorial because the API is small and consistent. This is a deliberate IA choice, not an oversight.
- **Recurring concrete component** (the "ChitChat — You have a new message!" notification card) used across multiple concept pages.
- Confident, opinionated voice that anticipates skeptics directly.

**Steal:** the Quick Reference table at the top of API pages; live-rendered examples when the output is visual; "Why not just X?" pre-emption when your approach is contrarian.

---

## Cross-cutting patterns to reach for first

When you don't know which project to imitate, default to these patterns — they appeared in 4+ of the 21 projects:

- **Two-track structure** (tutorial surface separate from reference surface) — Svelte, Vue, React, Astro, Next.js, Solid, Django, FastAPI.
- **Per-page learning-objectives bullet** ("You will learn…", "In this chapter…") — React, Next.js, Astro.
- **API/paradigm toggles at the IA level** — Vue (Options/Composition), Next.js (App/Pages), Svelte (Svelte/SvelteKit).
- **LLM-friendly Markdown mirrors** — Vue, Next.js, Astro, Bun, Cloudflare. Now table stakes.
- **Tabbed code blocks for package managers / OS / runtime** — Astro, Solid, Next.js, Tailwind, Hono, Bun, Deno.
- **Cumulative tutorial that builds one real artifact** — Django polls, Next.js dashboard, Astro blog, Svelte tutorial, Rust guessing game, FastAPI's `read_item`.
- **Recap section at the end of each tutorial chapter** — React, Next.js, Astro.
- **Edit-on-GitHub + last-updated + report-issue** chrome at the foot of pages — Astro, Solid, Next.js, Svelte, Vue.
- **Pitfall / Gotcha / Troubleshooting callouts as a structural element** — React, Vue, Astro, Svelte, Solid.
- **Output-as-comment** in examples — Zod, MDN, TanStack.
- **Anticipated-failure inline callouts** ("Browser issues?", "Wait a minute…") — Cloudflare, Django.

If you're starting fresh and don't know what to default to: **two-track IA, "You will learn" bullets, cumulative example, recap-and-next-up, MDN-shaped reference pages, output-as-comment, package-manager tabs.** That bundle alone covers most of what makes praised docs feel praised.
