# ZEUS BUILD WORKFLOW — DEFAULT

This is the shared default for AI-assisted work in this repository.

## Core method
1. Baseline Lock — preserve approved behavior, layout, naming, dimensions, and constraints unless explicitly changed.
2. Karpathy Method — stay on goal, do not guess, surface uncertainty, ask only a truly blocking question, avoid over-engineering.
3. Token Saver — Compress → Map → Locate → Plan → Execute → Verify → Record.
4. Jev Router — use `typesafe-ai/jev` via Vercel AI Gateway only for fast typed routing, classification, scoring, stop/retry/continue decisions, and verification.
5. Main Model — use the strongest appropriate model for coding, design, research, writing, and complex reasoning.
6. Delivery Verification — test the actual target environment, interactions, open/share path, and acceptance criteria before calling work final.

## Apple/mobile default routing
For any current or future iPhone/iPad/mobile app work, inspect and route through `.agents/skills/apple-ship-stack/SKILL.md` or the runtime-equivalent Claude skill.

- Load only the Apple Ship modules relevant to the task.
- Apple Ship integrates with Baseline Lock + Karpathy + Token Saver + LEAN BUILD + STACK Goal/Context + Delivery Verification.
- Typical triggers: app icons/assets, SwiftUI/HIG review, accessibility, Siri/App Intents/Shortcuts/Spotlight, localization/String Catalogs/RTL, theming, onboarding, local-first behavior, StoreKit/monetization, local builds, privacy/permissions, TestFlight/App Store/App Review.
- Prefer current Apple documentation for release-sensitive requirements.
- Do not claim device, Siri, payment, App Store, or hardware success without verification.

## Jev rules
- Never use Jev as the primary creative/generative model.
- Never block the project if Jev or the gateway is unavailable; fall back to the normal workflow.
- Runtime secret: `AI_GATEWAY_API_KEY`; never commit it.

## Access rules
- GitHub is the current remote source of truth.
- Local-computer edits require an authorized remote-computer connection.
- If local access is unavailable, continue all work that can be completed safely in GitHub and record any local-only step as pending.
- Never claim local files were changed unless verified through an authorized computer connection.

## Finish gate
Do not call a build final until:
- required behavior is implemented,
- prior approved elements are preserved,
- secrets are not committed,
- target-device or target-runtime checks are complete where applicable,
- the delivered artifact/open path works,
- remaining limitations are stated clearly.
