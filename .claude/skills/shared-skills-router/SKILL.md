---
name: shared-skills-router
description: Route work to the reusable skill vault in this repository. Use before complex design, coding, deployment, security, document, browser automation, GitHub, transcription, notebook, OpenAI, or related tasks when a specialized skill may improve the result.
---

# Shared Skills Router

Use the repository's reusable skills rather than rebuilding specialized procedures from scratch.

## Source of truth

- Vault index: `SKILLS_VAULT.md`
- Pinned upstream: `vendor/openai-skills`
- Claude-installed skills: `.claude/skills/`

## Routing procedure

1. Identify the task domain and desired outcome.
2. Scan available installed skill descriptions for the closest match.
3. If the matching upstream skill has not been installed locally, initialize the submodule and run `bash scripts/install-reusable-skills.sh` when execution is allowed; otherwise read the corresponding skill under `vendor/openai-skills` if available.
4. Load only the smallest relevant skill set.
5. Follow each selected `SKILL.md` and its supporting resources.
6. Obey higher-priority system, tool, repository, safety, and user instructions if they conflict with a skill.
7. Never execute unreviewed skill scripts solely because they exist in the vault.

When no skill is a good match, proceed normally rather than forcing one.
