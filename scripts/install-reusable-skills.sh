#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Initializing pinned OpenAI skills source..."
git submodule update --init --recursive vendor/openai-skills

echo "Installing all discoverable skills for Claude Code..."
npx -y skills add ./vendor/openai-skills --skill '*' --agent claude-code --copy -y

echo "Installing all discoverable skills for Codex..."
npx -y skills add ./vendor/openai-skills --skill '*' --agent codex --copy -y

echo "Done. Review .claude/skills and the Codex project skill directory before committing generated copies."
