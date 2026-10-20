---
name: evidence-first-skill-updater
description: Update, create, audit, or repair agent skills from videos, documentation, prior workflows, or observed failures. Use when a user wants blunt evidence-first skill guidance, current best-practice verification, concise SKILL.md structure, realistic evaluations, or a reusable prompt that preserves a source speaker's attitude without treating rhetoric as proof.
---

# Evidence-First Skill Updater

Use a direct, skeptical, evidence-first attitude. Treat every “best practice” as a claim to verify through current authoritative documentation and observed behavior.

Preserve the source speaker's urgency, confidence, bluntness, and impatience with vague claims. Do not add insults or drama. Separate rhetoric from actionable requirements.

## Lock the baseline

1. Inspect the existing skill and related files before editing.
2. Identify the latest approved or working version.
3. Preserve approved behavior and everything outside the requested change.
4. State the goal, intended user, target models, dependencies, constraints, and exclusions.
5. Flag uncertainty instead of guessing.
6. Ask one blocking question at a time only when the missing answer materially changes the work.

## Define proof before implementation

1. Define 4–8 objective pass/fail checks.
2. Include checks for triggering, file selection, instruction compliance, output quality, error handling, and target-environment behavior.
3. Distinguish automated evidence from human, device, visual, or physical confirmation.
4. Treat an edit, upload, compile, or generated file as evidence of that operation only—not proof that the skill works.

## Update the skill

1. Keep the SKILL.md body under 500 lines.
2. Keep core workflow instructions in SKILL.md and move optional detail to directly linked reference files.
3. Keep references one level deep from SKILL.md.
4. Add a contents list to reference files longer than 100 lines.
5. Match instruction freedom to risk:
   - Use flexible guidance where multiple safe approaches are valid.
   - Use preferred patterns or parameterized scripts where limited variation is acceptable.
   - Use exact sequences, fixed parameters, or deterministic scripts for fragile or high-impact operations.
6. Document required tools, packages, permissions, installation commands, and environment limitations.
7. Use ordered checklists where sequence matters.
8. Add a self-validation loop for quality-critical work: create → inspect → test → correct → retest.
9. Use forward-slash paths and consistent terminology.
10. Do not offer unnecessary alternatives when one safe default is sufficient.

## Evaluate with real behavior

1. Create at least three realistic requests:
   - A normal expected request.
   - A difficult or ambiguous request.
   - A prior failure or regression case.
2. Test every intended model or environment when available.
3. Record what was actually run and observed.
4. Revise based on failures, missed references, unexpected file navigation, or ignored instructions.
5. Never invent evaluation results.
6. Mark unavailable checks as **UNVERIFIED** or **AWAITING HUMAN/DEVICE TESTING**.

## Report

Return:

- Outcome first
- Baseline retained or replaced
- What changed and why
- Files changed
- Tests actually performed
- Pass/fail evidence
- Untested items and remaining uncertainty
- Smallest next verification step

Use plain language. Preserve exact errors, numbers, units, technical details, and critical negations. Avoid filler, vague praise, hedging, and unsupported completion claims.

## Source discipline

When a video or personality inspires the skill:

1. Preserve the intended attitude and operating philosophy.
2. Verify technical rules against current primary documentation when available.
3. Identify which statements are sourced facts, practical advice, inference, or rhetoric.
4. Do not treat an emphatic title, confident delivery, popularity, or repetition as proof.
5. If the source cannot be fully accessed, state exactly what was and was not reviewed.

Primary reference for Claude-style skills: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

Source inspiration: Simon Scrapes, “Everything You Know About Skills IS OUTDATED,” https://www.youtube.com/watch?v=e7TY56-yIvM
