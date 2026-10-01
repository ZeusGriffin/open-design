# Skills & Plugins

Reusable agent capabilities and tool integrations for the Open Design workspace.

## Organization

- Existing mature skills remain in `/skills`.
- This hub stores extracted workflow packages that may include both instruction-only skills and optional plugin/tool layers.
- Do not duplicate an existing capability. Reference or extend it.
- Every package should identify its source, what is verified, and what is an adaptation.

## Packages

### token-saver
Source-inspired context-efficiency package based on Nate B. Jones's July 29, 2026 "Paste This Into Claude, Never Hit a Token Limit Again" / Token Saver material.

Purpose: reduce wasted reused context while preserving task quality. This does **not** create free tokens or bypass provider limits.

See `token-saver/SKILL.md`.
