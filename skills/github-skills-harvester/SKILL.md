# GitHub Skills Harvester

## Purpose
Turn useful tutorials, repositories, videos, and technical walkthroughs into reusable skills for ChatGPT and Claude, then organize them in GitHub without duplicating existing material.

## Trigger
Use when the user says to:
- grab skills from a video/repo/article
- organize them in GitHub
- make them reusable for ChatGPT and Claude
- create prompt/code packs
- avoid duplicate files or duplicate repositories

## Workflow
1. Inspect the source and identify reusable procedures, tools, commands, repo patterns, or checklists.
2. Separate:
   - concepts
   - repeatable workflows
   - install/setup steps
   - code/templates
   - verification steps
3. Search the target repository for similar skills before adding anything.
4. Reuse or extend existing files when possible. Do not duplicate.
5. Create a compact folder:
   - SKILL.md
   - prompts/chatgpt.md
   - prompts/claude.md
   - templates/
   - references/
6. Every skill must include:
   - purpose
   - trigger
   - inputs
   - exact workflow
   - verification
   - failure modes
   - reusable prompt
7. Prefer copy-paste-ready commands and small files over long prose.
8. Preserve source attribution in references/source.md.
9. Finish with a short verification checklist.

## Verification
- Confirm files exist in the target repo.
- Confirm no duplicate skill already existed.
- Confirm ChatGPT and Claude prompt variants are included.
- Confirm code/templates are usable without needing the original video open.

## Failure modes
- Do not claim a video was fully transcribed unless it actually was.
- Do not invent repo contents.
- Do not create a new repo when an existing skills/design repo is the correct home.
- Do not silently overwrite an existing file; fetch first, then update intentionally.
