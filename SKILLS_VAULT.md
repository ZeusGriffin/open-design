# Reusable Agent Skills Vault

This repository keeps a pinned, reusable source of agent skills for Claude Code, Codex, ChatGPT-compatible agent workflows, and other Agent Skills clients.

## Provenance

- Original reference supplied by Zee: https://youtube.com/shorts/rMw6YJz0Ows?is=AGeLHhLV8ntBZiON
- The Short's title/transcript could not be independently retrieved when this vault was created, so no unverified claim is made about which repository the creator named.
- Verified upstream selected for the reusable base: https://github.com/openai/skills
- Pinned upstream commit: `49f948faa9258a0c61caceaf225e179651397431`
- Vendored as Git submodule: `vendor/openai-skills`

## Verified curated catalog

At the pinned source revision, the curated catalog contains these 39 skill directories:

1. aspnet-core
2. chatgpt-apps
3. cli-creator
4. cloudflare-deploy
5. define-goal
6. figma-code-connect-components
7. figma-create-design-system-rules
8. figma-create-new-file
9. figma-generate-design
10. figma-generate-library
11. figma-implement-design
12. figma-use
13. figma
14. gh-address-comments
15. gh-fix-ci
16. hatch-pet
17. jupyter-notebook
18. linear
19. migrate-to-codex
20. netlify-deploy
21. notion-knowledge-capture
22. notion-meeting-intelligence
23. notion-research-documentation
24. notion-spec-to-implementation
25. openai-docs
26. pdf
27. playwright-interactive
28. playwright
29. render-deploy
30. screenshot
31. security-best-practices
32. security-ownership-map
33. security-threat-model
34. sentry
35. speech
36. transcribe
37. vercel-deploy
38. winui-app
39. yeet

The upstream repository also contains non-curated/system/experimental/documentation skill content. The submodule preserves the full repository, not only the list above.

## Initialize the pooled source

```bash
git submodule update --init --recursive
```

## Install for Claude Code + Codex

From the repository root:

```bash
bash scripts/install-reusable-skills.sh
```

The installer copies all discoverable upstream skills into the agent-specific project skill directories while preserving this pinned source as the vault of record.

## How agents should use the vault

1. Inspect the available skill descriptions before starting a complex task.
2. Load the smallest relevant skill or skill set rather than blindly applying every skill.
3. Follow the selected `SKILL.md` workflow and its supporting files.
4. Treat tool availability and repository instructions as higher-priority runtime constraints.
5. Review third-party or updated skills before executing scripts or commands from them.

## Updating later

Update the submodule intentionally, review the upstream diff, then rerun the installer. Do not silently float to an unreviewed upstream revision.
