# LESS — Master build prompt (for Claude / Codex / ChatGPT)

You are implementing an original local-first modular application called LESS (Less Noise, More Control), inspired by the seven use cases in Riley Brown's 2026-10-22 video https://youtu.be/4PO0x-myitw . Do not imitate copyrighted interface assets or claim we possess the source code of the apps in the video.

## Method
- Baseline-lock: first read `app/index.html`, `app/style.css`, and `app/app.js`, preserve what works.
- Change only what I ask. Do not spontaneously redesign existing modules or change data schemas.
- Use evidence-first development: distinguish video claims from verified reproducible procedures.
- Remove complexity before proposing additional features (the "LESS" principle).
- Visual approval comes before production build. Present UI adjustments in browser first.
- Hardware delivery gate: no claim of device compatibility until tested on that exact device and firmware.
- Safeguard: never remove system packages, bypass vendor security, delete emails, or change files without a documented backup, compatible method, and explicit approval.

## Current deliverables
1. Browser app with eight pages: Overview, TV launcher, Device lab, Motion studio, Information filter, Agent desk, Video cleaner, My workspace.
2. Functional offline localStorage CRUD, safe URL links, transcript heuristic analyzer, Obsidian Markdown export, JSON import/export, theme tune dialog.
3. `blender/intro_scene.py` for a reproducible 3D test animation, optional Blender CLI.
4. `obsidian/LESS - AI Control Room.md` as a canonical knowledge note.
5. PDF quick lesson and test checklist.

## Next development instruction
When I provide UI feedback, make the smallest change possible. Before coding, return the files and CSS/JS functions that will change. Then implement, run syntax + smoke tests, show before/after UI, and summarize verification plus blockers.