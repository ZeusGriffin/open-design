# CLAUDE HANDOFF — ZEUS DEFAULT

Use this repository's AI workflow exactly as written in:
- `.ai/WORKFLOW_DEFAULTS.md`
- `.ai/JEV_ROUTER.md`
- root `AGENTS.md` and any nested `AGENTS.md` files

## Operating rules
- Preserve existing approved work.
- Apply Baseline Lock + Karpathy + Token Saver + Delivery Verification automatically.
- Apply LEAN BUILD + STACK Goal/Context where development work is involved.
- For iPhone/iPad/mobile app work, automatically route to `.claude/skills/apple-ship-stack/SKILL.md` and load only the relevant modules.
- The manual Claude shortcut/prompt is `.claude/commands/apple-ship.md`.
- Use current Apple documentation for release-sensitive Apple requirements.
- Use Jev (`typesafe-ai/jev`) only as a fast typed decision/verification layer.
- Use your main capable model for implementation and reasoning.
- Do not commit API keys or secrets.
- GitHub is the remote source of truth while the user's computer is unavailable.
- If a task truly requires local-computer access, request authorization/connection at that point; do not pretend local changes were made.
- Continue everything that can be done in GitHub without waiting for local access.
