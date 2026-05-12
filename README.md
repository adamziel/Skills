# AI Skills

A small, portable skills plugin. Currently ships:

- **code-review** — focused, severity-grouped review of the current branch's diff or a specified PR.
- **autonomous-loop** — creates a durable repo-local build loop that repeatedly reprompts Codex or Claude with persistent memory, progress, quiet logs, Git commits, tests, and fail-fast observability. `/adversarial-loop` remains a compatibility alias.
- **docs** — write tutorial / onboarding documentation for a software library (zero to familiarity), with embedded interactive code examples. Distilled from 21 highly-praised OSS docs sites (Svelte, Vue, React, Rust Book, FastAPI, Django, MDN, Tailwind, Astro, Next.js, ...).
- **writing-pr-descriptions** — clear, punchy, human-oriented PR descriptions: four sections (What it does, Rationale, Implementation, Testing instructions), specific over generic, no AI slop.
- **documenting-code** — developer-friendly code documentation: explains WHY not WHAT, documents constraints and edge cases, inspired by WordPress's HTML API docs style.
- **llm-wiki** — create, maintain, query, and lint persistent LLM-maintained markdown wikis from raw sources, based on Andrej Karpathy's LLM Wiki pattern.

The skill files (`skills/*/SKILL.md`) are plain markdown with YAML frontmatter and are the single source of truth — both Claude Code and Codex read the same files.

## Layout

```
.claude-plugin/
  plugin.json          # Claude Code plugin manifest
  marketplace.json     # Claude Code marketplace entry (so this repo is its own marketplace)
skills/
  code-review/SKILL.md
  autonomous-loop/SKILL.md
  adversarial-loop/SKILL.md  # compatibility alias for autonomous-loop
  docs/SKILL.md
  docs/references/          # page-templates.md, source-projects.md
  writing-pr-descriptions/SKILL.md
  documenting-code/SKILL.md
  llm-wiki/SKILL.md
commands/
  code-review.md            # /code-review slash command
  autonomous-loop.md        # /autonomous-loop slash command
  adversarial-loop.md       # compatibility alias for /autonomous-loop
  docs.md                   # /docs slash command
  writing-pr-descriptions.md  # /writing-pr-descriptions slash command
  documenting-code.md       # /documenting-code slash command
  llm-wiki.md               # /llm-wiki slash command
scripts/
  install-codex.sh     # symlink skills + commands into ~/.codex/
AGENTS.md              # entry point Codex reads automatically
```

## Install in Claude Code

Clone this repo, add the working copy as a marketplace, then install the plugin:

```
git clone https://gitea.zielinscy.dev/adam/ai-skills.git ~/code/ai-skills
/plugin marketplace add ~/code/ai-skills
/plugin install skills@adamziel-skills
```

After install, `/code-review`, `/autonomous-loop`, `/adversarial-loop`, `/docs`, `/writing-pr-descriptions`, `/documenting-code`, and `/llm-wiki` are available as slash commands, and the skills auto-trigger when their descriptions match the request.

To develop locally, edit the cloned working copy and pull updates with `git pull`.

## Install in Codex

Codex doesn't have a plugin system yet, but it does read `~/.codex/prompts/*.md` for slash commands and (when enabled) `~/.codex/skills/<name>/SKILL.md` for skills. The installer script symlinks both:

```
git clone https://gitea.zielinscy.dev/adam/ai-skills.git ~/code/ai-skills
~/code/ai-skills/scripts/install-codex.sh
```

Then in Codex, `/code-review`, `/autonomous-loop`, `/adversarial-loop`, `/docs`, `/writing-pr-descriptions`, `/documenting-code`, and `/llm-wiki` work the same way.

If your Codex build doesn't yet support skill auto-discovery, the slash commands still work because `commands/*.md` reference the skill files explicitly — Codex will read them via the prompt body.

## Updating

Both installs use symlinks to the cloned repo, so `git pull` is the update path.
