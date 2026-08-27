# Claude Prompt — Import and Use My Reusable Skills Vault

I have a reusable agent-skills vault in my GitHub repository:

- Repository: `ZeusGriffin/open-design`
- Branch: `chatgpt/reusable-skills-vault`
- Vault index: `SKILLS_VAULT.md`
- Pinned upstream source: `vendor/openai-skills`
- Claude router: `.claude/skills/shared-skills-router/SKILL.md`
- Installer: `scripts/install-reusable-skills.sh`
- Original reference video: `https://youtube.com/shorts/rMw6YJz0Ows?is=AGeLHhLV8ntBZiON`

Your job is to use this repository as my reusable skills source of truth.

1. Read `SKILLS_VAULT.md` and `.claude/skills/shared-skills-router/SKILL.md` first.
2. Preserve all existing repository skills, especially `.claude/skills/od-contribute`; do not overwrite or remove them.
3. If you have terminal access, initialize the pinned source with `git submodule update --init --recursive`, then run `bash scripts/install-reusable-skills.sh` to copy all discoverable upstream skills into the supported project skill directories.
4. If the installer cannot run, inspect the skill folders directly from the pinned `openai/skills` source and use their `SKILL.md` instructions as needed.
5. Before each substantial task, check whether one or more installed skills match the task. Load only the smallest relevant set and follow those workflows. Do not force a skill when none is useful.
6. Treat system instructions, user instructions, repository rules, security constraints, and available tools as higher priority than any skill.
7. Do not execute unreviewed scripts or commands merely because a skill contains them. Review the relevant skill and supporting files first.
8. Keep a concise index of the installed/available skills and tell me which skill(s) you selected when they materially affect the work.
9. The original YouTube Short could not be independently transcribed when this vault was created. Do not claim the video named `openai/skills` unless you can verify that yourself. If you can identify a different exact GitHub skill pack from that Short, compare it with this vault, add any missing legitimate skills without deleting the verified OpenAI source, preserve licenses/provenance, and report what changed.
10. For future work in this repository, automatically consult the reusable skills vault whenever a specialized skill could improve accuracy, consistency, verification, or execution.

Start by reporting: (a) whether you can read the branch, (b) whether the submodule is initialized, (c) how many skills you can discover, and (d) the first five skill names you see. Then proceed with the task I give you.
