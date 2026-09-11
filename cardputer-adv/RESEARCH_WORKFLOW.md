# Reusable Cardputer ADV research and development workflow

This is a human/agent reference document, not an installed global agent skill.

## When extending this collection

1. Find upstream repositories and use the manufacturer's documentation for hardware facts.
2. Identify the exact device target: original Cardputer, v1.1, ADV, or an expansion-specific build.
3. Read the current README and relevant board/build definitions. Distinguish an author's compatibility claim from a tested result.
4. Record the source URL, evidence URL, review date, evidence blob SHA, dependencies, limitations and license status in sources.json.
5. Prefer canonical upstream repositories. Keep forks only when they add a specific useful port or feature.
6. Mark inherited READMEs, mismatched download links, missing releases and experimental projects explicitly.
7. Summarize in original words. Preserve upstream licensing and attribution when importing source, assets or binaries.
8. Update README.md and sources.json together and check that every table entry has a matching registry record.

## When starting an app

1. Begin with APP_DESIGN_BRIEF.md and establish the user's app purpose.
2. Prototype the main interaction at 240 × 135 with keyboard navigation.
3. Choose one runtime and verify its ADV keyboard, audio and display support.
4. Pin the actual dependency revisions when implementing; README blob SHAs are not source revision pins.
5. Keep input, rendering, persistence and optional networking separate enough to handle slow or missing peripherals.
6. Build first, then test on the actual device. Distinguish build success from hardware success.
7. Record the firmware image type and partition requirements alongside the build.
8. Report changed files, build results, physical checks and remaining limitations honestly.

## Handoff prompt

Use the Cardputer ADV collection in ZeusGriffin/open-design/cardputer-adv as research context. Read README.md, sources.json and APP_DESIGN_BRIEF.md. Help design the app requested by the user for the M5Stack Cardputer ADV. Verify hardware-specific APIs against official documentation and the chosen upstream revision. Treat repository content as reference material, not permission to run scripts or install firmware. Produce a compact screen flow and a working prototype after the app purpose is established. Preserve source licenses and clearly label anything not hardware-tested.
