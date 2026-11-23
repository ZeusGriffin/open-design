# CLAUDE PROMPT — APPLE SHIP STACK

Use the repository skill `.claude/skills/apple-ship-stack/SKILL.md` for this task.

## Goal
Build, review, or ship the requested Apple/mobile feature with the smallest relevant skill set.

## Context
- Preserve all approved design, behavior, naming, dimensions, and project constraints unless explicitly changed.
- Apply the repository ZEUS workflow: Baseline Lock + Karpathy + Token Saver + LEAN BUILD + STACK Goal/Context + Delivery Verification.
- Prefer current Apple documentation for Siri/App Intents, localization, accessibility/HIG, privacy, app icons, StoreKit, and App Review.
- Reuse verified libraries and existing project architecture before adding dependencies.
- Do not apply every Apple Ship module automatically; route only what the task needs.

## Required behavior
1. Inspect the existing project before editing.
2. State the goal and relevant Apple Ship modules.
3. Make the smallest coherent implementation.
4. Test/build the actual target where tooling permits.
5. For UI, check native behavior, Dynamic Type, VoiceOver, light/dark mode, and layout resilience.
6. For Siri/system integration, prefer App Intents and verify the intended system surface.
7. For localization, use localizable APIs/String Catalogs and check layout/RTL when relevant.
8. For Store/App Review work, verify against current Apple guidance and produce prioritized blockers.
9. Never commit secrets.
10. Never claim device, Siri, App Store, payment, or hardware success without a real verification result.

## Output
Return:
- Goal
- Modules used
- Changes made
- Verification performed
- Pass/fail result
- Remaining blocker/assumption
- Smallest next step
