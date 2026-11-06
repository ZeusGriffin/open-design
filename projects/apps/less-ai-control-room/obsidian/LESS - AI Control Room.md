---
title: "LESS — AI Control Room"
created: 2026-11-05
tags: [AI, build, UX, video-research, LESS]
source: https://youtu.be/4PO0x-myitw
status: baseline-v0.1
---
# LESS — AI Control Room

**North star:** Remove software clutter and repetitive interactions. Build only the functions actually needed.

## Source and reliability
- Video: [Riley Brown — How Smart People Are Using AI Right Now (7 Insane Use Cases)](https://youtu.be/4PO0x-myitw), published October 22, 2026.
- Third-party transcript-based breakdown: https://github.com/dimthink/awesome-ai-podcast-notes/blob/main/channels/riley-brown/2026-10-22-how-smart-people-are-using-ai-right-now-(7-insane-use-cases)-4PO0x-myitw.md
- This is a conceptual adaptation, not a release or fork of the presenter's proprietary apps. Video speed, cost and hardware claims are **not independently verified**.

## Ideas → modules
| # | Concept | Module | Initial proof |
|---|---|---|---|
| 1 | Personal TV launcher | TV launcher | Editable, browser-based service tiles |
| 2 | Adapt owned devices | Device lab | Exact-model plan + reversible checklist |
| 3 | AI-generated 3D motion | Motion studio | Four-shot prompt + Blender starter script |
| 4 | AI filters information | Information filter | Manual triage queue; no auto-delete |
| 5 | Agents replace apps | Agent desk | Reusable prompt generation |
| 6 | Cut video filler | Video cleaner | Rule-based transcript review with JSON export |
| 7 | Build custom software | My workspace | Local notes/tasks + Markdown/JSON export |

## Priority builds
- [x] Catalog all seven use cases and map to modules
- [x] Build dependency-free browser app
- [x] Preserve adjustable design tokens
- [x] Write prompt library and lesson PDF
- [ ] Obtain UI review and specific visual changes
- [ ] Validate on target iPhone/iPad and Windows desktop
- [ ] Verify TV make/model and SDK before native launcher
- [ ] Choose secure read-only connector if inbox integration is desired
- [ ] Run Blender animation in an actual Blender installation

## Architecture
- `app/index.html` — shell
- `app/style.css` — tokens and responsive styling
- `app/app.js` — routes, UI, event handlers, client-local content
- `prompts/` — repeatable Claude/Codex instructions
- `blender/intro_scene.py` — original procedural 3D demonstration

## Test gate
Open `index.html`, exercise each screen, export JSON and Markdown. Data is browser-local and unencrypted. Never put confidential records, API keys, or personal secrets in this prototype.

## Next iteration template
**UI feedback:**
**Affected screen:**
**Elements to change:**
**Elements to preserve:**
**Acceptance check:**