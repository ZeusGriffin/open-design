# APPLE SHIP STACK — Research Notes

Created from a current review of Apple documentation and reusable mobile agent skills.

## Verified upstream references

- Code-with-Beto/skills — public mobile skill pack. Current public catalog includes ship coach, onboarding, mobile UI, theming, local-first, AI image flow, monetization, app icon, local build, and app launch.
- Apple App Intents — modern system integration for Siri, Spotlight, Shortcuts, widgets, controls, and Apple Intelligence surfaces.
- Apple SwiftUI localization + Xcode String Catalogs.
- Apple Human Interface Guidelines — App icons and current appearance variants.
- Apple App Store Review Guidelines.
- Optional third-party deeper review references: apple-hig and Apple App Review compliance skills.

## Design decision

This repository uses one routed composite skill instead of auto-loading many overlapping skills. That keeps context smaller, reduces contradictory instructions, and lets the agent load only the modules required by the current task.

## Refresh rule

Before an App Store submission or other release-sensitive work, re-check current Apple documentation rather than treating this file as a permanent policy snapshot.
