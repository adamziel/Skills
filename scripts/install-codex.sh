#!/usr/bin/env bash
# Install this plugin's skills and commands into Codex CLI's user config.
#
# Codex CLI looks for:
#   ~/.codex/prompts/*.md            -> custom slash commands
#   ~/.codex/skills/<name>/SKILL.md  -> custom skills (when skills support is enabled)
#
# This script symlinks the plugin's commands and skills into those locations so
# the same source-of-truth files are used by Claude Code and Codex.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PROMPTS_DIR="$CODEX_HOME/prompts"
SKILLS_DIR="$CODEX_HOME/skills"

mkdir -p "$PROMPTS_DIR" "$SKILLS_DIR"

link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "skip: $dst exists and is not a symlink" >&2
    return
  fi
  ln -sfn "$src" "$dst"
  echo "linked: $dst -> $src"
}

for cmd in "$REPO_ROOT/commands"/*.md; do
  link "$cmd" "$PROMPTS_DIR/$(basename "$cmd")"
done

for skill_dir in "$REPO_ROOT/skills"/*/; do
  name="$(basename "$skill_dir")"
  link "${skill_dir%/}" "$SKILLS_DIR/$name"
done

echo
echo "Done. In Codex you can now use:"
for cmd in "$REPO_ROOT/commands"/*.md; do
  echo "  /$(basename "$cmd" .md)"
done
