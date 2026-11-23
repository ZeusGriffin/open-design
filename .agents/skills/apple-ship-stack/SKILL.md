---
name: apple-ship-stack
description: End-to-end Apple/mobile shipping skill for iOS-first app work. Use automatically for new or existing iPhone/iPad app projects when work touches app icons, SwiftUI UI review, Apple HIG/accessibility, Siri/App Intents/Shortcuts/Spotlight, localization, theming, onboarding, local-first data, StoreKit/monetization, local builds, privacy/permissions, App Store metadata, or App Review readiness. Load only the relevant modules.
---

# APPLE SHIP STACK — ZEUS

A reusable Apple/mobile project skill integrated with the ZEUS BUILD WORKFLOW.

## Core rule

Do not apply every module blindly. Route to the smallest relevant set, preserve the approved baseline, and verify before delivery.

Always combine with:
- Baseline Lock
- Karpathy Method
- Token Saver
- LEAN BUILD
- STACK Goal + Context
- Delivery Verification

## 0. Goal + Context gate

Before editing:
1. State the concrete goal in one sentence.
2. Identify the current platform and framework: SwiftUI/UIKit, React Native/Expo, or other.
3. Identify the target Apple OS/device(s).
4. Preserve approved behavior, layout, naming, and assets unless the request changes them.
5. Separate verified facts from assumptions and experimental ideas.
6. Use current Apple documentation for release-sensitive rules.

## 1. App Icon + Store Asset module

Use when creating or changing app identity/assets.

Checks:
- Produce a recognizable 1024x1024 master.
- Follow current Apple app-icon guidance for supported appearance variants.
- Do not bake system corner masks/device frames into the artwork.
- Keep core visual identity consistent across default/dark/clear/tinted appearances.
- Verify asset-catalog or framework integration.
- For Expo/React Native, prefer a proven icon pipeline such as Code-with-Beto's app-icon workflow when compatible.
- Keep source artwork and generated platform assets reproducible.

Acceptance:
- Icon renders correctly in the actual target project.
- No missing required asset references.
- Store artwork matches the app's current brand.

## 2. SwiftUI + Apple HIG review module

Use when creating, reviewing, or refactoring Apple UI.

Review:
- Native navigation and platform patterns.
- Semantic colors and automatic light/dark behavior.
- Dynamic Type and text scaling.
- VoiceOver labels, traits, reading order, and meaningful accessibility values.
- Touch targets, safe areas, keyboard behavior, focus, and reduced-motion behavior.
- SF Symbols where appropriate.
- State/data flow and SwiftUI composition.
- Layout resilience across supported device sizes.
- Performance risks caused by unnecessary view invalidation or heavy work on the main thread.

Prefer current Apple APIs and avoid generic "Apple-looking" UI that ignores native behavior.

Acceptance:
- UI builds.
- Core path is usable with accessibility settings.
- No approved visual or behavior regression.

## 3. Siri + App Intents + system surfaces module

Use when a useful app action or entity should be accessible outside the app.

Modern default:
- Prefer App Intents for Siri, Spotlight, Shortcuts, widgets, controls, Action Button, and Apple Intelligence system discovery where supported.
- Treat legacy SiriKit/Intents patterns as compatibility-only unless the target requires them.

Workflow:
1. Identify the smallest high-value user action.
2. Model any app entities needed.
3. Add AppIntent/AppShortcut definitions.
4. Provide useful parameter titles, phrases, summaries, and results.
5. Make the intent route into existing app/domain logic instead of duplicating business logic.
6. Test intent execution and failure cases.
7. Verify appearance in the intended system surface when tooling/hardware allows.

Acceptance:
- Intent performs the same underlying action as the app.
- Invalid/missing inputs fail clearly.
- Do not claim Siri/Spotlight success until tested.

## 4. Localization + RTL module

Use for user-facing text, internationalization, or App Store locales.

Workflow:
- Put user-visible text in localizable APIs.
- Prefer Xcode String Catalogs for Apple-native projects.
- Add translator comments where context matters.
- Handle plurals and locale-sensitive numbers, dates, measurements, and currencies.
- Check truncation and expansion.
- Test right-to-left layout where applicable.
- Keep accessibility labels localized.
- Keep App Store metadata/screenshots aligned with supported locales.

Acceptance:
- No obvious hard-coded user-visible strings in the changed surface.
- At least the base locale and requested target locale build/render correctly.
- RTL-sensitive layouts are checked when relevant.

## 5. Theming + onboarding + local-first modules

Load only when relevant.

Theming:
- Use semantic design tokens.
- Preserve system light/dark behavior.
- Avoid scattered platform conditionals when a shared token works.

Onboarding:
- Shortest path to first useful result.
- Avoid permission prompts before context explains why they are needed.
- Preserve a usable path for returning users.

Local-first:
- Define source of truth.
- Define migration strategy.
- Define offline behavior and recovery checks.
- Test data loss/recovery paths before shipping risky schema changes.

## 6. Monetization + StoreKit module

Use only when the app sells digital goods/subscriptions or access.

Checks:
- Product IDs and environments.
- Purchase, pending, cancellation, failure, restore, and entitlement states.
- Clear pricing/terms.
- Access persists correctly after relaunch/account changes where intended.
- No home-grown payment flow that conflicts with current App Store rules.

Verify current Apple policy before submission because commerce rules can change.

## 7. Build + install module

Use before calling a mobile change "done."

For native Apple:
- Build the actual scheme/configuration.
- Prefer release-like validation in addition to previews.
- Test simulator and physical device when the feature depends on hardware/system integration.

For Expo/React Native:
- Validate config and native generation.
- Use a local installable build when practical.
- Do not equate Metro/dev-server success with release success.

Record:
- target,
- build command/tool,
- result,
- blocker if any.

## 8. Privacy + permission module

Use whenever code touches camera, microphone, photos, files, Bluetooth, location, contacts, notifications, health, tracking, or other protected data.

Checks:
- Permission purpose strings are accurate and specific.
- Request timing is contextual.
- Only required capabilities/entitlements are enabled.
- Privacy manifests/disclosures match actual SDK/data behavior.
- Secrets are never committed.

## 9. App Store + App Review preflight module

Use before TestFlight/App Store submission or when diagnosing a rejection.

Run a fresh review against current Apple guidance.

Check:
- app completeness and crash-free core flow,
- accurate metadata, screenshots, URLs, and version/build numbers,
- privacy/permission disclosures,
- account/login/demo-review access,
- required hardware explanation/video where applicable,
- in-app purchase visibility and restore path where applicable,
- account deletion and other policy-sensitive flows where applicable,
- non-obvious features documented in review notes,
- no placeholder/debug content.

Output findings as:
- BLOCKER
- HIGH
- MEDIUM
- PASS

Every issue must include:
- evidence,
- likely guideline/risk,
- smallest fix,
- verification step.

## 10. Optional reusable upstream skills

When available and compatible, prefer verified reusable skills over rebuilding procedures:
- Code-with-Beto public mobile skills for app icon, mobile UI, theming, onboarding, local-first, monetization, local build, and launch readiness.
- Apple HIG/SwiftUI specialist skills for deeper native UI review.
- App Review compliance skills for structured preflight.

Review third-party skill instructions before executing scripts.

## 11. Finish gate

Do not mark Apple/mobile work complete until the relevant checks pass:
- requested behavior works,
- approved baseline is preserved,
- build succeeds in the intended target where possible,
- UI/accessibility checks are complete for affected screens,
- protected-data changes are reviewed,
- Siri/App Intents/localization/store claims are verified rather than assumed,
- limitations/blockers are explicitly recorded.

## Current primary references

- Apple App Intents documentation
- Apple SwiftUI localization documentation
- Apple String Catalog documentation
- Apple Human Interface Guidelines: App icons
- Apple App Store Review Guidelines
- Code-with-Beto/skills public mobile skill pack

Refresh release-sensitive facts before shipping.
