# Skills

This repo is a portable skills plugin. The source of truth for each skill is
`skills/<name>/SKILL.md`. Slash-command wrappers live in `commands/<name>.md`.

When asked to do a code review, follow `skills/code-review/SKILL.md`.
When asked to create or run an autonomous build loop, or when asked for the legacy adversarial-loop workflow, follow `skills/autonomous-loop/SKILL.md`.
When asked to advance a stacked PR, address reviews/CI/merge, or find/create the next PR in a stack, follow `skills/merge-and-open-next-in-stack/SKILL.md`.
When asked to run a supervised multi-session team, parallel Codex/tmux workers, or resource-aware supervised exploration with a selectable intensity, follow `skills/supervised-team/SKILL.md`.
When asked to write tutorial / onboarding documentation for a software library, follow `skills/docs/SKILL.md`.
When asked to create, maintain, query, or lint an LLM-maintained wiki / knowledge base, follow `skills/llm-wiki/SKILL.md`.

These files are plain markdown with YAML frontmatter and are designed to be
read directly by either Claude Code or Codex without modification.
